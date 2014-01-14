Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaANXwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:52:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59165 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaANXw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:52:27 -0500
Message-ID: <52D5CDA1.3050306@zytor.com>
Date: Tue, 14 Jan 2014 15:52:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Add Clovertrail and Merrifeld support to Intel
 MID
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com> <20140114224419.GB9834@psi-dev26.jf.intel.com>
In-Reply-To: <20140114224419.GB9834@psi-dev26.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 02:44 PM, David Cohen wrote:
> On Mon, Dec 16, 2013 at 12:07:35PM -0800, David Cohen wrote:
>> Hi,
>>
>> I've a bunch of Intel MID patches under review but it seems they are becoming
>> old and start to need changes.
>> I gathered an up-to-date version of all of them in this single patch set.
>>
>> This series implements support of Clovertrail and Merrifield to Intel MID.
>> It also removes the unwanted X86_MDFLD option since *all* Intel MID platforms
>> should be supported through CONFIG_X86_INTEL_MID option.
>>
>> This makes obsolete the following patches:
>> https://lkml.org/lkml/2013/10/18/480
>> https://lkml.org/lkml/2013/10/22/533
>> http://lkml.indiana.edu/hypermail/linux/kernel/1311.1/02937.html
> 
> Ping :)
> Any comments on this whole patch set?
> 

You got some feedback from Bjorn and Ingo... mostly description-related,
but that is important enough.

Other than that we should queue it up ASAP.

	-hpa



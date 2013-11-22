Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3KVBNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:13:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60065 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3KVBNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:13:36 -0500
Message-ID: <528EAF99.1010503@zytor.com>
Date: Thu, 21 Nov 2013 17:12:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jerry Hoemann <jerry.hoemann@hp.com>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com,
        yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, penberg@kernel.org,
        mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com> <20131121230744.GA31592@srcf.ucam.org> <528E94D1.2050809@zytor.com> <20131121233705.GA32121@srcf.ucam.org>
In-Reply-To: <20131121233705.GA32121@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 03:37 PM, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 03:18:41PM -0800, H. Peter Anvin wrote:
>> On 11/21/2013 03:07 PM, Matthew Garrett wrote:
>>> This is a problem we have to solve, but I don't think this is the right 
>>> way to solve it. Why do we not just reattempt to perform the allocation 
>>> immediately after we've freed the boot services regions?
>>>
>>
>> Wouldn't the memory map already have gotten scrambled all to hell by then?
> 
> If we couldn't map a 64MB region in low memory earlier then it's likely 
> to have been because there was a 64MB or greater boot services region.
> 

I thought the problem was that they wanted to map a fairly large chunk
for faster kdump and fragmentation was being a problem.

	-hpa


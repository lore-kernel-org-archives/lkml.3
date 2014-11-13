Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaKMGzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:55:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaKMGy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:54:59 -0500
Message-ID: <546455C1.6000405@suse.com>
Date: Thu, 13 Nov 2014 07:54:57 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 5/8] x86: Introduce function to get pmd entry pointer
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-6-git-send-email-jgross@suse.com> <20141112221204.GD7549@laptop.dumpdata.com>
In-Reply-To: <20141112221204.GD7549@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 11:12 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 11, 2014 at 06:43:43AM +0100, Juergen Gross wrote:
>> Introduces lookup_pmd_address() to get the address of the pmd entry
>> related to a virtual address in the current address space. This
>> function is needed for support of a virtual mapped sparse p2m list
>> in xen pv domains.
>>
> What is wrong with using 'lookup_address' ?

It doesn't return the needed information. I need a pmd entry here, not
a pte entry.


Juergen

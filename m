Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3HFUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:45:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55682 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3HFUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:45:11 -0400
Message-ID: <52016047.5060903@linux.vnet.ibm.com>
Date: Tue, 06 Aug 2013 15:44:55 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/8] Add all memory via sysfs probe interface at once
References: <51F01E06.6090800@linux.vnet.ibm.com> <51F01EFB.6070207@linux.vnet.ibm.com> <20130802023259.GC1680@concordia> <51FC04C2.70100@linux.vnet.ibm.com> <20130805031326.GB5347@concordia>
In-Reply-To: <20130805031326.GB5347@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080707-3568-0000-0000-0000040BE036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2013 10:13 PM, Michael Ellerman wrote:
> On Fri, Aug 02, 2013 at 02:13:06PM -0500, Nathan Fontenot wrote:
>> On 08/01/2013 09:32 PM, Michael Ellerman wrote:
>>> On Wed, Jul 24, 2013 at 01:37:47PM -0500, Nathan Fontenot wrote:
>>>> When doing memory hot add via the 'probe' interface in sysfs we do not
>>>> need to loop through and add memory one section at a time. I think this
>>>> was originally done for powerpc, but is not needed. This patch removes
>>>> the loop and just calls add_memory for all of the memory to be added.
>>>
>>> Looks like memory hot add is supported on ia64, x86, sh, powerpc and
>>> s390. Have you tested on any?
>>
>> I have tested on powerpc. I would love to say I tested on the other
>> platforms... but I haven't.  I should be able to get a x86 box to test
>> on but the other architectures may not be possible.
> 
> Is the rest of your series dependent on this patch? Or is it sort of
> incidental?
> 
> If possible it might be worth pulling this one out and sticking it in
> linux-next for a cycle to give people a chance to test it. Unless
> someone who knows the code well is comfortable with it.
> 

I am planning on pulling the first two patches and sending them out
separate from the patch set since they are really independent of the
rest of the patch series.

The remaining code I will send out for review and inclusion in
linux-next so it can have the proper test time as you mentioned.

-Nathan


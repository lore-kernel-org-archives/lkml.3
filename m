Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936549Ab3DRT6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:58:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41521 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab3DRT6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:58:22 -0400
Message-ID: <51705034.4030101@zytor.com>
Date: Thu, 18 Apr 2013 12:57:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Josh Triplett <josh@joshtriplett.org>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf> <51704FA8.7060801@console-pimps.org>
In-Reply-To: <51704FA8.7060801@console-pimps.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 12:55 PM, Matt Fleming wrote:
> On 04/18/2013 05:44 PM, Josh Triplett wrote:
>>>> The machine I developed the BGRT changes on kept the image below the 4G
>>>> mark, inside one of the memory regions reclaimable via
>>>> ExitBootServices().
>>>
>>> Well, highmem is >= ~896M.  Do you have a machine with BGRT over the
>>> highmem mark?
>>
>> I don't have the machine in question anymore, and I don't remember.
> 
> Sorry, I should have been more clear - having a BGRT image in highmem
> has never worked for the reasons I outlined in my previous mail. What I
> was really asking was: is it OK that we now explicitly don't support
> that case? I'm working on the assumption that it's pointless writing
> support for the BGRT in highmem because no such i386 machines exist. If
> the BGRT code works for your i386 right now, the address isn't in highmem.
> 
> If there are machines out there that would require us to write support,
> it's probably worth doing now instead of punting. But it sounds like
> there aren't any.
> 

I suspect if there aren't any yet there WILL be.

	-hpa


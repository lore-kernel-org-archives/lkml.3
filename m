Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936585Ab3DRULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:11:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:11953 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936525Ab3DRULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,503,1363158000"; 
   d="scan'208";a="297121046"
Message-ID: <51705366.8070001@intel.com>
Date: Thu, 18 Apr 2013 13:11:18 -0700
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf> <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf> <51704FA8.7060801@console-pimps.org> <1366315083.13667.19.camel@x230.lan>
In-Reply-To: <1366315083.13667.19.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 12:58 PM, Matthew Garrett wrote:
> On Thu, 2013-04-18 at 20:55 +0100, Matt Fleming wrote:
> 
>> If there are machines out there that would require us to write support,
>> it's probably worth doing now instead of punting. But it sounds like
>> there aren't any.
> 
> I would expect that if there are any 32-bit UEFI systems that ship with
> BGRT support (and Darren makes it sound like that's a possibility),
> there's a realistic chance of the BGRT ending up allocated above the
> highmem barrier.

I can certainly ensure we sit below that barrier on the MinnowBoard. We
can also speak with the Intel UEFI firmware development teams to see
about making that a requirement. I don't know if we'll be successful,
but Matt, Peter, and I have recently coaxed some changes of that nature in.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

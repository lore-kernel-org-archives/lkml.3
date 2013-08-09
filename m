Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab3HIPc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:32:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45240 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963Ab3HIPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:32:27 -0400
Message-ID: <1376062345.2087.16.camel@dabdike.int.hansenpartnership.com>
Subject: Re: RFC: default CONFIG_EFI_STUB=y
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Date: Fri, 09 Aug 2013 08:32:25 -0700
In-Reply-To: <52050985.9070107@zytor.com>
References: <52050985.9070107@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 08:23 -0700, H. Peter Anvin wrote:
> I would like to change the defaults for CONFIG_EFI and CONFIG_EFI_STUB
> to y.  There is little reason to omit this since EFI now is a
> significant percentage of all systems.

You didn't actually attach the patch, but I presume this is for 64 bit
compiles on x86 only?  We still have significant problems getting 64 bit
EFI to interact with 32 bit kernels, so I don't believe we should enable
CONFIG_EFI globally for all of x86.

James



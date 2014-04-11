Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaDKSfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:35:09 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42666 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaDKSfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <53483487.6030103@zytor.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<53483487.6030103@zytor.com>
Date: Fri, 11 Apr 2014 14:35:05 -0400
Message-ID: <CAMzpN2jVAZS61uicMRbyR45PrL+WBKNWH52DN_E3CYaCcOAjWg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/11/2014 11:27 AM, Brian Gerst wrote:
>> Is this bug really still present in modern CPUs?  This change breaks
>> running 16-bit apps in Wine.  I have a few really old games I like to
>> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.
>
> It is not a bug, per se, but an architectural definition issue, and it
> is present in all x86 processors from all vendors.
>
> Yes, it does break running 16-bit apps in Wine, although Wine could be
> modified to put 16-bit apps in a container.  However, this is at best a
> marginal use case.


Marginal or not, it is still userspace breakage.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3DZQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:40:49 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37975 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130426163022.GC23038@console-pimps.org>
References: <20130426163022.GC23038@console-pimps.org>
Date: Fri, 26 Apr 2013 09:40:46 -0700
X-Google-Sender-Auth: uCSaHzGlr40hgk2fj-Sbk2xNZ0s
Message-ID: <CA+55aFw+EOcVvz-3Sc-khBuLsMo64pp8PDO_UwidH07vbC08pA@mail.gmail.com>
Subject: Re: [GIT PULL] EFI urgent fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 9:30 AM, Matt Fleming <matt@console-pimps.org> wrote:
> Hi Peter, Linus,
>
> I've got a small patch that fixes a crash for the Google folks and their
> EFI SMI driver, which was caused by dereferencing a garbage pointer.

Hmm. I already took this from the earlier email you sent. Did it change since?

            Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3DZQsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:48:51 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54523 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab3DZQsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:48:50 -0400
Date: Fri, 26 Apr 2013 17:48:45 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Michel Lespinasse <walken@google.com>
Subject: Re: [GIT PULL] EFI urgent fix
Message-ID: <20130426164845.GD23038@console-pimps.org>
References: <20130426163022.GC23038@console-pimps.org>
 <CA+55aFw+EOcVvz-3Sc-khBuLsMo64pp8PDO_UwidH07vbC08pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+EOcVvz-3Sc-khBuLsMo64pp8PDO_UwidH07vbC08pA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr, at 09:40:46AM, Linus Torvalds wrote:
> On Fri, Apr 26, 2013 at 9:30 AM, Matt Fleming <matt@console-pimps.org> wrote:
> > Hi Peter, Linus,
> >
> > I've got a small patch that fixes a crash for the Google folks and their
> > EFI SMI driver, which was caused by dereferencing a garbage pointer.
> 
> Hmm. I already took this from the earlier email you sent. Did it change since?

Nope, there hasn't been any change. I just didn't know whether you
preferred to take the fix via email or a pull request.

Thanks for picking this up.

-- 
Matt Fleming, Intel Open Source Technology Center

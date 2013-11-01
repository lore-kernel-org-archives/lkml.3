Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3KAIWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:22:46 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:45264 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3KAIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:22:43 -0400
Date: Fri, 1 Nov 2013 09:22:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] Move drivers/acpi/apei/cper.c to drivers/firmware/efi/
Message-ID: <20131101082240.GB27021@gmail.com>
References: <52700d2920076a466d@agluck-desk.sc.intel.com>
 <20131031093718.GA9453@gmail.com>
 <CA+8MBb+UJNusv_gb4ys6UEuFA_OYxoBRgNKeHF0G6jxkEFJ1Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+UJNusv_gb4ys6UEuFA_OYxoBRgNKeHF0G6jxkEFJ1Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@gmail.com> wrote:

> On Thu, Oct 31, 2013 at 2:37 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > Hm, it's not very well tested:
> >
> >   drivers/firmware/efi/Kconfig:41: syntax error
> >   drivers/firmware/efi/Kconfig:40: unknown option "defbool"
> 
> Gah!  That's exactly what I found yesterday ... and fixed the typo to change
> to "def_bool" ... and *tried* to "git --amend" before I tagged and
> sent the pull.
> 
> To mash up Yoda and Mythbusters:
>   There is no try - only fail

;-)

> Just re-did it ... and according to gitweb the new tag is there 
> and points at the new commit with the "def_bool" version.

Looks good here, thanks Tony!

	Ingo

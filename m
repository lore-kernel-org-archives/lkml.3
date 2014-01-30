Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaA3AqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:46:19 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:39810 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA3AqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140129163407.a46408a4.akpm@linux-foundation.org>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
	<CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
	<20140129015048.GA14629@konrad-lan.dumpdata.com>
	<CA+8MBbJjEUJKo2ip8bDzDRVbBT+yhzqZXV0BYP3X52OJ3zA6Pg@mail.gmail.com>
	<CAE9FiQWfZk7ogmORm7euBy1bncUhFW0Ms2hV_g8_9uBVU71RRQ@mail.gmail.com>
	<CAE9FiQX6CiumfOi2cgU1ODrKuaTHCZxo3zNmW01kn+GT1CAT3w@mail.gmail.com>
	<CA+8MBbLggLtM6ZQhmS0qZQaRG0b+HxtawxXSu5bUzHS-rMVcYg@mail.gmail.com>
	<20140129163407.a46408a4.akpm@linux-foundation.org>
Date: Wed, 29 Jan 2014 16:46:17 -0800
Message-ID: <CA+8MBb+=uN+=imrAAK+=CXQf3LjZov3JKT2rVKyD90d4HgM0Uw@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Tony Luck <tony.luck@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 4:34 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> It applies for me.  MIME getting you down?

Perhaps - Gmail's web client showed me a downward pointing arrow when I
moused over the attachment icon in Yinghai's e-mail. So I clicked it ... and
it looked like it downloaded a patch-like looking file. So I ran
"patch -p1 < file"
and whoops - that wasn't so great after all :-(

Your plain text e-mail version applied just fine.

GUI: 0 CLI: 1

Patch works - my ia64 boots again.  Thanks.

Tested-by: Tony Luck <tony.luck@intel.com>

-Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaKULdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:33:06 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:49749 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKULdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:33:04 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 12:32:54 +0100
Message-ID: <1962959.JkOx4gJGaG@xrated>
User-Agent: KMail/4.14.3 (Linux/3.11.10-21-desktop; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141120164531.GB3596@tucsk>
References: <20141120164531.GB3596@tucsk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IJtElC0Ypu+sW+g4U7MjxujSFJ6v5FeOTuq1/ZC+2Ia
 vhJtbMW3WHDwxzZm4b43TKXxj3bBg8uxyY2F8LxP5Om84aWHoe
 +OnfNYwbLhBjR5IwT5/Gx08l8O9+jY4NPGd7GLKcPVCV4b1uTH
 GtXj8esSmxosSepb/6Traic2aDogzcKINFoqX8exO75KM5iUIk
 7OD9g3To38456np6RJc6Ygn+GwDq+WeAtPkgxTB2GEjtqPuaQm
 h2IIIasW9U+OZ+t0DlL9PRS4PaqHWCntbg+G9JbgiLFCE/p3ew
 p7n8S/YqhUQl6jwt176+HOlJuiS2sYl2Gl4OcyremsQ9YKbfg=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Miklos,

On Donnerstag, 20. November 2014 17:45:31 Miklos Szeredi wrote:
> 
> The biggest change is to rename the filesystem from "overlayfs" to
> "overlay". This will allow legacy overlayfs to be easily carried by distros
> alongside the new mainline one.

Would you kindly give a firm elaboration of this rename? 

Why would a distro kernel maintainer want to keep the external overlayfs 
patches together with the now in kernel module?

Isn't it enough to drop the external patches from distro kernels in order to 
use it successfully or are there any semantic changes hidden that an admin 
should know about?

BTW: congrats to all involved parties. A layered filesystem finally arrived in 
the Linux kernel! This is a quantum leap for creative system architects.

Cheers,
Pete

proud user of aufs (and formerly unionfs) based fat diskless systems since 
about a decade.

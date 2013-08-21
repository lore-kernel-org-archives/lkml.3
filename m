Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3HUNA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:00:58 -0400
Received: from ugs.tarent.de ([193.107.123.165]:56112 "EHLO ugs.tarent.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3HUNA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:00:56 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 09:00:55 EDT
Date: Wed, 21 Aug 2013 14:53:30 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
X-X-Sender: tglase@tglase.lan.tarent.de
To: Richard Weinberger <richard@nod.at>
cc: linux-arch@vger.kernel.org, mmarek@suse.cz, geert@linux-m68k.org,
        ralf@linux-mips.org, lethal@linux-sh.org, jdike@addtoit.com,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [RFC] Get rid of SUBARCH
In-Reply-To: <1377073172-3662-1-git-send-email-richard@nod.at>
Message-ID: <alpine.DEB.2.10.1308211452260.31430@tglase.lan.tarent.de>
References: <1377073172-3662-1-git-send-email-richard@nod.at>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Richard Weinberger wrote:

> The series touches also m68k, sh, mips and unicore32.
> These architectures magically select a cross compiler if ARCH != SUBARCH.
> Do really need that behavior?

Not precisely that, but it’s very common in m68k land
to just cross-build kernels with

$ make ARCH=m68k menuconfig
$ make ARCH=m68k

Maybe a generalising of that feature, and making it
independent of SUBARCH (which can then die)?

bye,
//mirabilos
-- 
[16:04:33] bkix: "veni vidi violini"
[16:04:45] bkix: "ich kam, sah und vergeigte"...

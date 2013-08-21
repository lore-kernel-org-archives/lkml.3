Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3HUND4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:03:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39145 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3HUNDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:03:55 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.10.1308211452260.31430@tglase.lan.tarent.de>
References: <1377073172-3662-1-git-send-email-richard@nod.at> <alpine.DEB.2.10.1308211452260.31430@tglase.lan.tarent.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] Get rid of SUBARCH
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 14:58:04 +0200
To: Thorsten Glaser <t.glaser@tarent.de>, Richard Weinberger <richard@nod.at>
CC: linux-arch@vger.kernel.org, mmarek@suse.cz, geert@linux-m68k.org,
        ralf@linux-mips.org, lethal@linux-sh.org, jdike@addtoit.com,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Message-ID: <7813eeb3-8f96-4d3d-87ec-f2a880122804@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ARCH doesn't match uname for some definition of match?

Thorsten Glaser <t.glaser@tarent.de> wrote:
>On Wed, 21 Aug 2013, Richard Weinberger wrote:
>
>> The series touches also m68k, sh, mips and unicore32.
>> These architectures magically select a cross compiler if ARCH !=
>SUBARCH.
>> Do really need that behavior?
>
>Not precisely that, but it’s very common in m68k land
>to just cross-build kernels with
>
>$ make ARCH=m68k menuconfig
>$ make ARCH=m68k
>
>Maybe a generalising of that feature, and making it
>independent of SUBARCH (which can then die)?
>
>bye,
>//mirabilos

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

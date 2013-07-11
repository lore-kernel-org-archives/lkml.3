Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3GKJqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:46:46 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52495 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3GKJqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:46:43 -0400
Date: Thu, 11 Jul 2013 11:46:40 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Borislav Petkov <bp@alien8.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH] .gitignore: ignore *.lz4 files
Message-ID: <20130711094640.GA358@x4>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130506095124.GA22041@pd.tnic>
 <CAMuHMdWH9w5fj6HRXi+9QcBJym4dukAFsPVGZVqSSk3yTZJUcA@mail.gmail.com>
 <20130710093642.GC14873@pd.tnic>
 <20130710182815.GA362@x4>
 <20130711043433.GA29245@hulk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711043433.GA29245@hulk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that lz4 kernel compression is available, add *.lz4 to .gitignore.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>

diff --git a/.gitignore b/.gitignore
index 3b8b9b3..7e9932e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,6 +29,7 @@ modules.builtin
 *.bz2
 *.lzma
 *.xz
+*.lz4
 *.lzo
 *.patch
 *.gcno
-- 
Markus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaJWUPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:15:36 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57919 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaJWUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:15:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: opw-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, john.stultz@linaro.org
Subject: git tree for y2038 patches, to be added to linux-next
Date: Thu, 23 Oct 2014 22:15:24 +0200
Message-ID: <8455153.NY1892ffCa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LjgdL/+pn1dGZPr7ZIzz5LIvBkQAj77prr8O786JImn
 JHZ6pV20w8MZTEJ8slRW9sWJRLbgvXp9LlfMuOnC8TKrjchQCd
 jcqvmbzgrcM5GDTa7+FnCbgZZ6fFjbaPpkBrlAMbIRAbpcbZ/P
 OKyaFTn1yfpJbzf+TJqZ6ETBa9bp7z05jbxaXXoiXVUrXqdkk2
 ETHcXYa5xsE69Y3A2XLjl8OS6CUzNPqPjlJY0VsCB3dDADLcip
 DwIMnylEq8O3y+fts2Au9DW4nAncgBj9fumLMag2fr5YBnkMkJ
 jt3xL0BRPjw8Sl3qw4D85l3Qa86rflhOyVDlAALhRjfz4HKZOL
 ibIHY7k5wyUb046mQsEc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I'm collecting patches for 64-bit time_t conversion. I'm getting patches
for this topic from the OPW application, and hopefully soon from an intern
in the program.

The plan is to have most of the patches being  merged through subsystem
maintainer trees as much as possible, but I also want to give them linux-next
exposure as early as possible, in particular since a lot of the code that
is being changed is not actively maintained.  I will send the remaining
patches to Thomas Gleixner so he can put them into the tip tree.

Please add

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git y2038

to linux-next. At the moment there is only one simple patch in it,
I assume there will be more soon.

	Arnd

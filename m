Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3AXK2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:28:07 -0500
Received: from mout.gmx.net ([212.227.15.18]:59589 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3AXK17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:27:59 -0500
Cc: linux-kernel@vger.kernel.org, dave.anglin@bell.net, jejb@parisc-linux.org,
        linux-parisc@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="utf-8"
Date: Thu, 24 Jan 2013 11:27:56 +0100
From: "Helge Deller" <deller@gmx.de>
In-Reply-To: <CAMuHMdViEAXdm=iYXeejdnxw_Xj_7HF63DcUojwBm-G+UeSeuw@mail.gmail.com>
Message-ID: <20130124102756.213380@gmx.net>
MIME-Version: 1.0
References: <50FF006C.7070803@gmx.de>
 <CAMuHMdViEAXdm=iYXeejdnxw_Xj_7HF63DcUojwBm-G+UeSeuw@mail.gmail.com>
Subject: Re: [GIT PULL] parisc fixes for v3.8-rc5
To: Geert Uytterhoeven <geert@linux-m68k.org>, deller@gmx.de
X-Authenticated: #1045983
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18MBm8Fe20M4rfynzgD0p2KOSz6Km6TaVsIdpXEOO
 1HqKN+t8H793qEWtuUDBDX9Aus8DZPX18q7Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: +2lzcT4yeSEqX76WZHQhtEt+IGRvb8DP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

From: Geert Uytterhoeven <geert@linux-m68k.org>
> On Tue, Jan 22, 2013 at 10:11 PM, Helge Deller <deller@gmx.de> wrote:
> > please consider pulling the following 4 patches for 3.8-rc5 which
> improve
> > the stability of the linux kernel on the parisc architecture.
> 
> I think you forgot https://patchwork.kernel.org/patch/1917351/

I did not scheduled it as bug fix for 3.8, since the HPUX support is broken in the parisc tree anyway.

But I did not forgot your patch either. It's in my local git repository and will go in for kernel 3.9. That's why it's in state "accepted" in patchwork already.
I hope that's OK for you?

Helge

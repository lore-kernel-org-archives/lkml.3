Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3ALVGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:06:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48032 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3ALVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:06:29 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
References: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com> <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com> <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de> <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz> <20130112183619.GC10630@liondog.tnic> <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sat, 12 Jan 2013 21:05:15 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <cf1e4936-c572-48b0-9fac-1d2cf418bae2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan is dealing with family stuff that is far more important. Someone who has the time needs to own this and the fb layer. Not a don't care - a don't have time.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3IJSci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:32:38 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56619 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3IJSch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
Date: Tue, 10 Sep 2013 11:32:36 -0700
X-Google-Sender-Auth: xXEST4Kw3jg5k-2nSlVGBo4yqiI
Message-ID: <CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mace Moneta <moneta.mace@gmail.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:29 AM, Mace Moneta <moneta.mace@gmail.com> wrote:
> I can patch and compile a kernel if you post the patch you want tested.

It was attached in that previous email..

Apparently I'm not the only one who misses things like versions in
subject lines or other small "details" in emails ;)

           Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3IJUZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:25:30 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:39401 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3IJUZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<CAMfhy93EoDohCrV+ykj6b+R9QSCTdiPtvSpJpe3SH=ot_1LWMg@mail.gmail.com>
	<CA+55aFxvAn=jTbQXxery54uaaq=QsLzJgPdwnTd8B77abc92jQ@mail.gmail.com>
	<CAMfhy92u1GFvTrO+8SNp8hoEBEHcd7Z-3mw+79rv8+2yYqa+ow@mail.gmail.com>
	<CAMfhy90vEu2_hfoOnzB+ZOit4HNmKex2WObmztcY7R4+PBwd7w@mail.gmail.com>
Date: Tue, 10 Sep 2013 13:25:28 -0700
X-Google-Sender-Auth: 6wsxe9rKqFGzHeVgYK2LIdbZ4Lc
Message-ID: <CA+55aFzFWbCGqaGe1BbuBY_j+0xK-UfYEJddjSWriufs0Q5PmQ@mail.gmail.com>
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

On Tue, Sep 10, 2013 at 12:57 PM, Mace Moneta <moneta.mace@gmail.com> wrote:
> The (first) patch looks good; no recurrence. It has only taken 3-5 minutes
> before, and I've been up for about half an hour now.

Ok, good. It's pushed out.

Al, your third pile of VFS stuff is also merged. Waiman, that means
that your RCU path creation stuff is in. What else did you have
pending for scalability?

                Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3IJRrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:47:24 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59958 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3IJRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
Date: Tue, 10 Sep 2013 10:47:21 -0700
X-Google-Sender-Auth: zZ7BusX-PST0JLUTKFoQdIWtMIM
Message-ID: <CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        moneta.mace@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:39 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> The subject says v3.11-7890-ge5c832d, which is the git-describe output
> of the mainline kernel for that Fedora build.

Duh. I just read the bugzilla and the oops ;)

But yes, e5c832d is obviously the "fixed" kernel. Let me think about this.

         Linus

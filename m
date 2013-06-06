Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3FFMPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:15:08 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:38274 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3FFMPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:15:06 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 08:15:06 EDT
Date: Thu, 6 Jun 2013 11:52:27 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: schmitz <schmitz@biophys.uni-duesseldorf.de>
cc: Chen Gang <gang.chen@asianux.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, schmitz@debian.org,
        Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl'
 and 'outsl' need '<< 2'
In-Reply-To: <51AEE7C0.9060206@biophys.uni-duesseldorf.de>
Message-ID: <Pine.BSM.4.64L.1306050936200.18048@herc.mirbsd.org>
References: <51A71E49.1000707@asianux.com>
 <CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com>
 <51A93FA0.1050203@biophys.uni-duesseldorf.de> <51A94281.7050708@biophys.uni-duesseldorf.de>
 <51AC6472.3060606@asianux.com> <CAMuHMdVLA_zgeGxTTzfXnBYZiihH3w+LLcW0cRzVk_dvkFojgg@mail.gmail.com>
 <51AE87DF.5000301@asianux.com> <51AEE7C0.9060206@biophys.uni-duesseldorf.de>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schmitz dixit:

> No need for the #ifdef CONFIG_Q40 - Q40 is the only m68k subarch that builds
> the parport_pc module (which includes parport.h), IIRC. Is that correct,
> Thorsten?

The header is included outside of Q40. There is no Q40 kernel
in Debian (yet). So, no.

bye,
//mirabilos
-- 
17:08⎜«Vutral» früher gabs keine packenden smartphones und so
17:08⎜«Vutral» heute gibts frauen die sind facebooksüchtig
17:10⎜«Vutral» aber auch traurig; früher warst du als nerd voll am arsch
17:10⎜«Vutral» heute bist du als nerd der einzige der wirklich damit klarkommt

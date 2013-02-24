Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3BXNoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 08:44:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:58633 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab3BXNoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 08:44:03 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/b9E0Vf2vbOFSGUpJF2SJI5fphJon0SVTMZ1AyLW
	E5o7GdeaHkeldR
Message-ID: <512A191F.8080005@gmx.de>
Date: Sun, 24 Feb 2013 14:43:59 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130111 Thunderbird/17.0.2
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [uml-user] v3.8-6988-g9e2d59a compile error
References: <5129F39D.10900@gmx.de> <CAFLxGvx8hx42GX-u4850bqZu6doRabPKeLVGeQ1VDoO4_27TSA@mail.gmail.com>
In-Reply-To: <CAFLxGvx8hx42GX-u4850bqZu6doRabPKeLVGeQ1VDoO4_27TSA@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 12:18 PM, richard -rw- weinberger wrote:
> The compiler got -EIO while opening include/asm-generic/mutex-null.h.
> Maybe a you should fsck your disk first. :-)
> 

gah -...

$ rm include/asm-generic/mutex-null.h
$ git checkout include/asm-generic/mutex-null.h

did it

- thx


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaJSXF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:05:27 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49162 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaJSXF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <20141019210348.GA28144@drone.musicnaut.iki.fi>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
	<20141019210348.GA28144@drone.musicnaut.iki.fi>
Date: Sun, 19 Oct 2014 16:05:25 -0700
X-Google-Sender-Auth: 6qucCIm1laGmQL3Ml_Qw4dV50HU
Message-ID: <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, Andrew Pinski <pinskia@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 2:03 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
>
> Here's one example how it fails: http://marc.info/?l=gcc&m=141349914632010&w=2

Ok, that just looks like a gnu11 bug, then. Not being able to
initialize structures because some sub-structure has a volatile member
is just pure BS.

Has anybody reported this as a gcc bug? That email may be on the gcc
list, but I'm not seeing anybody acknowledge it as a bug..

I cannot imagine that anybody sane claims that this is *wanted*
behavior from "gnu11".

                       Linus

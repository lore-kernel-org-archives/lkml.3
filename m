Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaAWTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:11:24 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:40138 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaAWTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
Date: Thu, 23 Jan 2014 11:11:19 -0800
X-Google-Sender-Auth: Dk8cYcCrHk-_sMB4l3tK37-Rh4g
Message-ID: <CA+55aFykzCSKeXgBEiFTozVqbBvJUiK2bdTDfRO80sqZZS8TXw@mail.gmail.com>
Subject: Re: [PATCH 0/10] framebuffer patches
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Is there some reason why these are not going through Tomi? And
cc'd to linux-fbdev for that matter?

It's not that I can't apply patches sent directly to me, but quite
frankly, unless there is a *reason* to not go through the subsystem
maintainer I don't really want to. Afaik Tomi has been active and
responsive, but maybe there's some strife I don't know about..

             Linus

On Thu, Jan 23, 2014 at 10:17 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Here I'm sending some framebuffer patches for matrox, mach64, tga and a
> fix for copying on vesafb.
>
> Mikulas

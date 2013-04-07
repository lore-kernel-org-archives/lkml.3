Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3DGS2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 14:28:55 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41563 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934242Ab3DGS2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 14:28:53 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5160A81E.2010505@gmail.com>
References: <20130405174012.GA28836@kroah.com>
	<51606512.8030703@gmail.com>
	<20130406181836.GA2406@kroah.com>
	<51606D06.5020606@gmail.com>
	<CAKMK7uEF6sfvMvut7JVCjsKbgzarr8acqELnC0iLrHyKo=b+tQ@mail.gmail.com>
	<5160A81E.2010505@gmail.com>
Date: Sun, 7 Apr 2013 20:28:53 +0200
Message-ID: <CAKMK7uGjzYF0XG78US7OyoK2xnvn4jw25f26d28QS=CR_Ta=nQ@mail.gmail.com>
Subject: Re: Linux 3.8.6
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Lucas <canolucas@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>,
        "Kuoppala, Mika" <mika.kuoppala@intel.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 12:56 AM, Lucas <canolucas@gmail.com> wrote:
> Thanks for reporting in.
>
> Somehow the thread got all messed up in LKML. It didn't parse correctly
> there, but it seems that Gmane did. Here is the link:
>
> http://comments.gmane.org/gmane.linux.kernel.stable/48872

Those patches still have an unresolved regression against them.
Unfortunately  I can't reproduce it despite that I have a very similar
system, and obviously a bunch of other people like you reported that
the exact same patches which regressed actually fix the lvds panel
fitter. So for now this stays in limbo :(
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

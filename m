Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaEEHv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:51:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43521 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbaEEHv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:51:26 -0400
MIME-Version: 1.0
Date: Mon, 5 May 2014 09:51:25 +0200
Message-ID: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
Subject: [3.14.0-rc4] regression: drm FIFO underruns
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Cc: David Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still have FIFO underruns in drm:
[drm:ivb_err_int_handler] *ERROR* Pipe B FIFO underrun
[drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[drm:cpt_serr_int_handler] *ERROR* PCH transcoder B FIFO underrun

which I already reported here:
https://lkml.org/lkml/2014/4/9/127

and which is still unanswered!

I tried to bisect the thing, but I ran into compile errors. So I
can only say it came in with
e9f37d3 "Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux"

Jörg

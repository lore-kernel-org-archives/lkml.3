Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaKRNXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:23:37 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39717 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaKRNXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:23:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141118080317.73b6b29e@lwn.net>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
 <1416309821-5426-7-git-send-email-prabhakar.csengg@gmail.com> <20141118080317.73b6b29e@lwn.net>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Nov 2014 13:23:04 +0000
Message-ID: <CA+V-a8uC0en+hnsJEA_kUnJRUy4ha4Tb8OY1_JLRUSwHx-XbJQ@mail.gmail.com>
Subject: Re: [PATCH 06/12] media: marvell-ccic: use vb2_ops_wait_prepare/finish
 helper
To: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Tue, Nov 18, 2014 at 1:03 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 18 Nov 2014 11:23:35 +0000
> "Lad, Prabhakar" <prabhakar.csengg@gmail.com> wrote:
>
>>  drivers/media/platform/marvell-ccic/mcam-core.c | 29 +++++--------------------
>>  1 file changed, 5 insertions(+), 24 deletions(-)
>
> So I'm not convinced that this patch improves things; it moves a tiny bit
> of code into another file where anybody reading the driver will have to
> go look to see what's going on.  But I guess it doesn't really make
> things worse either; I won't try to stand in its way.  It would be nice
> to see a real changelog on the patch, though.
>
Sorry there is no movement of code to other file.  And I dont see any
reason why anybody reading will go haywire its a standard v4l2 thing.
The subject explains it all, If you still want me to elaborate I can
post a v2.

Thanks,
--Prabhakar Lad

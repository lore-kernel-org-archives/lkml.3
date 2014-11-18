Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaKRObg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:31:36 -0500
Received: from tex.lwn.net ([70.33.254.29]:37294 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbaKRObc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:31:32 -0500
Date: Tue, 18 Nov 2014 09:31:29 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] media: marvell-ccic: use
 vb2_ops_wait_prepare/finish helper
Message-ID: <20141118093129.06a5b3d3@lwn.net>
In-Reply-To: <CA+V-a8uC0en+hnsJEA_kUnJRUy4ha4Tb8OY1_JLRUSwHx-XbJQ@mail.gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
	<1416309821-5426-7-git-send-email-prabhakar.csengg@gmail.com>
	<20141118080317.73b6b29e@lwn.net>
	<CA+V-a8uC0en+hnsJEA_kUnJRUy4ha4Tb8OY1_JLRUSwHx-XbJQ@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 13:23:04 +0000
Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:

> Sorry there is no movement of code to other file.  And I dont see any
> reason why anybody reading will go haywire its a standard v4l2 thing.

Whatever, I said I wouldn't stand in the way.

> The subject explains it all, If you still want me to elaborate I can
> post a v2.

Here I totally disagree, though.  You say what you are doing, not why.
What's strange about the idea that a patch should have a reasonable
changelog?

jon

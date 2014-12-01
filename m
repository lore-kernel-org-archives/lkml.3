Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaLATwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:52:16 -0500
Received: from tex.lwn.net ([70.33.254.29]:56897 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbaLATwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:52:15 -0500
Date: Mon, 1 Dec 2014 14:52:08 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 06/11] media: marvell-ccic: use
 vb2_ops_wait_prepare/finish helper
Message-ID: <20141201145208.228b5d55@lwn.net>
In-Reply-To: <1417041754-8714-7-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
	<1417041754-8714-7-git-send-email-prabhakar.csengg@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 22:42:29 +0000
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> wrote:

> This patch drops driver specific wait_prepare() and
> wait_finish() callbacks from vb2_ops and instead uses
> the the helpers vb2_ops_wait_prepare/finish() provided
> by the vb2 core

This is good, what I had in mind.

> the lock member of the queue needs
> to be initalized to a mutex so that vb2 helpers
> vb2_ops_wait_prepare/finish() can make use of it.

This is excessive, but not worth worrying about.  Thanks for redoing
things.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon

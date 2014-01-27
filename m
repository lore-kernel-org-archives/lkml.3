Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaA0TVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:21:39 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:35953 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbaA0TVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:21:37 -0500
Date: Mon, 27 Jan 2014 13:21:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Masanari Iida <standby24x7@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] mm: Fix warning on make htmldocs caused by
 slab.c
In-Reply-To: <1390845428-6289-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.DEB.2.10.1401271321190.6125@nuc>
References: <1390845428-6289-1-git-send-email-standby24x7@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Masanari Iida wrote:

> This patch fixed following errors while make htmldocs
> Warning(/mm/slab.c:1956): No description found for parameter 'page'
> Warning(/mm/slab.c:1956): Excess function parameter 'slabp' description in 'slab_destroy'

Acked-by: Christoph Lameter <cl@linux.com>

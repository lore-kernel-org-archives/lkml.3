Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbbAEOxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:53:22 -0500
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:34346 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbbAEOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:53:21 -0500
Date: Mon, 5 Jan 2015 08:53:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] mm: don't use compound_head() in
 virt_to_head_page()
In-Reply-To: <1420421765-3209-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1501050852380.24090@gentwo.org>
References: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com> <1420421765-3209-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Joonsoo Kim wrote:

> This patch implements compound_head_fast() which is similar with
> compound_head() except tail flag race handling. And then,
> virt_to_head_page() uses this optimized function to improve performance.

Yeah that is how it was before and how it should be

Acked-by: Christoph Lameter <cl@linux.com>

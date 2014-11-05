Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaKEQvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:51:35 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:56541 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbaKEQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:51:33 -0500
Date: Wed, 5 Nov 2014 10:51:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] mm: slub: fix format mismatches in slab_err() callers
In-Reply-To: <1415200341-9619-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.11.1411051051140.27561@gentwo.org>
References: <1415200341-9619-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Andrey Ryabinin wrote:

> Adding __printf(3, 4) to slab_err exposed following:

Acked-by: Christoph Lameter <cl@linux.com>


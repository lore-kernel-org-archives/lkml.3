Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbbAUXB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:01:29 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:54442 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbbAUXBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:01:21 -0500
Date: Wed, 21 Jan 2015 15:01:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kim Phillips <kim.phillips@freescale.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: fix typo
In-Reply-To: <20150120140142.cd2e32d83d66459562bd1717@freescale.com>
Message-ID: <alpine.DEB.2.10.1501211459370.2716@chino.kir.corp.google.com>
References: <20150120140142.cd2e32d83d66459562bd1717@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Kim Phillips wrote:

> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Acked-by: David Rientjes <rientjes@google.com>

Although the patch description or title should probably say this is a typo 
in the comment of __slab_free().  It's good to differentiate typos in code 
vs comments for commit message readers who have to decide if they have to 
backport something.

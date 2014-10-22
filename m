Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaJVN5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:57:08 -0400
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:51729 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbaJVN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:57:05 -0400
Date: Wed, 22 Oct 2014 08:57:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slab_common: don't check for duplicate cache names
In-Reply-To: <alpine.LRH.2.02.1410211958030.19625@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.DEB.2.11.1410220856450.8892@gentwo.org>
References: <alpine.LRH.2.02.1410211958030.19625@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Mikulas Patocka wrote:

> 12220dea07f1ac6ac717707104773d771c3f3077), therefore we need stop checking
> for duplicate names even for the SLAB subsystem. This patch fixes the bug
> by removing the check.

Acked-by: Christoph Lameter <cl@linux.com>

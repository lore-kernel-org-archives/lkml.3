Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbaGVW6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:58:02 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45771 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaGVW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:57:58 -0400
Date: Tue, 22 Jul 2014 15:57:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vladimir Davydov <vdavydov@parallels.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch 0/2] mm, slub: remaining changes for -mm
Message-ID: <alpine.DEB.2.02.1407221550500.9885@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches remain in Pekka's slab/next branch that can deferred to 3.17 
but need to get pushed to -mm.

Unless there's an objection, it should be possible to remove Pekka's slab 
trees from linux-next until he starts pushing changes again.
---
 mm/slub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

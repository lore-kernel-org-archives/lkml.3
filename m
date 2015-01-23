Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbbAWVhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:37:42 -0500
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:57310 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbbAWVhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:37:37 -0500
Message-Id: <20150123213727.142554068@linux.com>
Date: Fri, 23 Jan 2015 15:37:27 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [RFC 0/3] Slab allocator array operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached a series of 3 patches to implement functionality to allocate
arrays of pointers to slab objects. This can be used by the slab
allocators to offer more optimized allocation and free paths.


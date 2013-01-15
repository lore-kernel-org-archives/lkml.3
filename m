Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3AORBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:01:08 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:36706 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab3AORBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:01:06 -0500
Date: Tue, 15 Jan 2013 09:01:05 -0800
From: Zach Brown <zab@zabbo.net>
To: Christoph Lameter <cl@linux.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] mm/slab: add a leak decoder callback
Message-ID: <20130115170105.GP12288@lenny.home.zabbo.net>
References: <1358143419-13074-1-git-send-email-bo.li.liu@oracle.com>
 <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013c3f0c8af2-361e64b5-f822-4a93-a67e-b2902bb336fc-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The merge processing occurs during kmem_cache_create and you are setting
> up the decoder field afterwards! Wont work.

In the thread I suggested providing the callback at destruction:

 http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21130.html

I liked that it limits accesibility of the callback to the only path
that uses it.

- z

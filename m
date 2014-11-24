Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750879AbaKXVfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:35:06 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:39913 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKXVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:35:03 -0500
Date: Mon, 24 Nov 2014 13:35:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Jianyu Zhan <nasa4836@gmail.com>, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, sasha.levin@oracle.com,
        n-horiguchi@ah.jp.nec.com, andriy.shevchenko@linux.intel.com,
        hannes@cmpxchg.org, vdavydov@parallels.com, fabf@skynet.be,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <jianyu.zhan@emc.com>
Subject: Re: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and
 GFP_HIGHUSER_MOVABLE
In-Reply-To: <20141124190127.GA5027@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.10.1411241334490.21237@chino.kir.corp.google.com>
References: <1416847427-2550-1-git-send-email-nasa4836@gmail.com> <20141124190127.GA5027@node.dhcp.inet.fi>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Kirill A. Shutemov wrote:

> But I would prefer to have GPF_HIGHUSER movable by default and
> GFP_HIGHUSER_UNMOVABLE to opt out.
> 

Sounds like a separate patch.

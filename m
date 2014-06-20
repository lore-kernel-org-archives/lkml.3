Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaFTUcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:32:45 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:50648 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbaFTUcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:32:43 -0400
Date: Fri, 20 Jun 2014 15:32:40 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Hugh Dickins <hughd@google.com>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: kernel BUG at /src/linux-dev/mm/mempolicy.c:1738! on v3.16-rc1
In-Reply-To: <alpine.LSU.2.11.1406201257370.8123@eggly.anvils>
Message-ID: <alpine.DEB.2.11.1406201531530.5221@gentwo.org>
References: <20140619215641.GA9792@nhori.bos.redhat.com> <alpine.DEB.2.11.1406200923220.10271@gentwo.org> <20140620194639.GA30729@nhori.bos.redhat.com> <alpine.LSU.2.11.1406201257370.8123@eggly.anvils>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Hugh Dickins wrote:

> [PATCH] mm: fix crashes from mbind() merging vmas
>
> v2.6.34's 9d8cebd4bcd7 ("mm: fix mbind vma merge problem") introduced
> vma merging to mbind(), but it should have also changed the convention
> of passing start vma from queue_pages_range() (formerly check_range())
> to new_vma_page(): vma merging may have already freed that structure,
> resulting in BUG at mm/mempolicy.c:1738 and probably worse crashes.

Good catch. Cannot find fault with what I see.

Acked-by: Christoph Lameter <cl@linux.com>

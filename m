Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaEIQeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:34:10 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:50243
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932253AbaEIQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:34:07 -0400
Date: Fri, 9 May 2014 11:34:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org,
        riel@redhat.com, minchan@kernel.org, zhangyanfei@cn.fujitsu.com,
        hanpt@linux.vnet.ibm.com, sasha.levin@oracle.com, oleg@redhat.com,
        fabf@skynet.be, mgorman@suse.de, aarcange@redhat.com, cldu@marvell.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: use a irq-safe __mod_zone_page_state in
 mlocked_vma_newpage()
In-Reply-To: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
Message-ID: <alpine.DEB.2.10.1405091133360.11810@gentwo.org>
References: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Jianyu Zhan wrote:

> Hi, Christoph, I'm sorry for the misleading phrasing.
> Would be this one OK? Thanks.

Good.

Reviewed-by: Christoph Lameter <cl@linux.com>

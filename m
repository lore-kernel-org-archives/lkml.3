Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaAVLS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:18:29 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:57670 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaAVLS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:18:28 -0500
Date: Wed, 22 Jan 2014 12:18:21 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, liuj97@gmail.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        iamjoonsoo.kim@lge.com, robin.m.holt@gmail.com,
        tangchen@cn.fujitsu.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 2/3] mm/memblock: Add support for excluded memory
 areas
Message-ID: <20140122121821.6da53a02@lilie>
In-Reply-To: <1390217559-14691-3-git-send-email-phacht@linux.vnet.ibm.com>
References: <1390217559-14691-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1390217559-14691-3-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012211-1948-0000-0000-0000078B4BD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

I'd like to remind that the s390 development relies on this patch
(and the next one, for cleanliness, of course) being added. It would be
very good to see it being added to the -mm tree resp. linux-next.

Kind regards

Philipp


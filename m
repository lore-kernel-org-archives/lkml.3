Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3HEIbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:31:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:15226 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3HEIbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:31:10 -0400
Message-ID: <51FF62C0.10105@huawei.com>
Date: Mon, 5 Aug 2013 16:30:56 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] cma: do some clean up
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. use "PFN_DOWN(r->size)" instead of "r->size >> PAGE_SHIFT".
2. adjust the function structure, one for the success path, 
the other for the failure path.

Xishi Qiu (2):
  cma: use macro PFN_DOWN when converting size to pages
  cma: adjust goto branch in function cma_create_area()

 drivers/base/dma-contiguous.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)


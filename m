Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3LRRXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:23:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3LRRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:23:42 -0500
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] Use lockless lists for smp_call_function_single()
Date: Wed, 18 Dec 2013 18:23:32 +0100
Message-Id: <1387387418-10005-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  these three patches make smp_call_function_single() use lockless lists and
cleanup abuse of csd.list in the block layer. I have some use for lockless
smp_call_function_single() in printk code and that's why I've picked up
Christoph's patch. Jens, can you have a look at the series please?

Changes since v1:
* Reordered patches to a more sensible order.

								Honza

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaEaQnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:43:49 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:56239 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaEaQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:43:48 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] blk-mq: fix schedule from atomic context
Date: Sun,  1 Jun 2014 00:43:35 +0800
Message-Id: <1401554617-10099-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

These two patches fix the problem of schedule from atomic context
which is introduced in bitmap based allocation.

Thanks,
--
Ming Lei


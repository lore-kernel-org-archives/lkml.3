Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaE0OUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:20:30 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58329 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaE0OU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:20:27 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] blk-mq: fix leak of hctx->ctx_map
Date: Tue, 27 May 2014 22:20:11 +0800
Message-Id: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc changes.

Thanks,
--
Ming Lei


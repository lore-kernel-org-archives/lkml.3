Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3J2USZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:18:25 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60849 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3J2USY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:24 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org
Subject: [PATCH] Immutable biovecs
Date: Tue, 29 Oct 2013 13:17:53 -0700
Message-Id: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - this patch series is ready to go, driver maintainers have reviewed and
tested it and the code's been essentially done for probably a year now - can we
get this into 3.13?


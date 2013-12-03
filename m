Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3LCVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:24:31 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58320 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3LCVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:24:17 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fixups for immutable biovecs
Date: Tue,  3 Dec 2013 13:24:06 -0800
Message-Id: <1386105848-25660-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - for the "silence spurious compiler warnings", if you want to drop the
previous version of that patch and replace with this one, it appears
uninitialized_var() doesn't work on structs. And I somehow lost the btrfs
fixes Chris Mason did for bio chaining and had to redo them so hopefully he
can glance at them, but it does pass xfstests.


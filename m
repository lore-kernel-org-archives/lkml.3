Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3JKAcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:32:51 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53575 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3JKAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:32:50 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: [PATCH] Fix for bcache regression
Date: Thu, 10 Oct 2013 17:31:14 -0700
Message-Id: <1381451475-24551-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply - the last fix in the bugfix series I sent you had an
embarassing screwup...

For 3.13, shall I start sending you pull requests directly?


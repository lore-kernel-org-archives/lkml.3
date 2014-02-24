Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaBXJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:31:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaBXJbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:31:15 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, eparis@parisplace.org
Subject: [PATCH 0/3] fsnotify: Fix handling of overflow events
Date: Mon, 24 Feb 2014 10:31:04 +0100
Message-Id: <1393234267-22937-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

  these three patches fix problems with overflow events in fanotify and
inotify frameworks. Part of that (patches 1 & 3) is a fallout of my
rewrite of fsnotify framework. I've implemented testing of generation of
overflow events for fanotify and inotify in LTP and with these patches
the tests pass. Please check whether the patches fix problems for you as
well. I plan to push these fixes to Linus soon...

								Honza

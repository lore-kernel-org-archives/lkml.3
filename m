Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3EaOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:45:49 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1404 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3EaOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:45:43 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: regcache-rbtree: Fixed node range check on sync
Date: Fri, 31 May 2013 16:45:12 +0200
Message-Id: <1370011513-10816-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes what I think is a bug in regcache_rbtree_sync().
It is something I noticed when reading the code, I don't have a test
scenario for it. So please review it carefully.

Bye,
		Maarten

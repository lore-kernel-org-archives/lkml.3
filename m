Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaHNJvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:51:33 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35695 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaHNJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:51:30 -0400
From: Li Wang <li.wang@windriver.com>
To: <dwmw2@infradead.org>, <Artem.Bityutskiy@nokia.com>, <stefani@seibold.net>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: mtd: put flash block erasing into wait queue, if has any thread in queue
Date: Thu, 14 Aug 2014 17:50:32 +0800
Message-ID: <1408009833-26494-1-git-send-email-li.wang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


flash erasing maybe block writing operation.
make erasing operation sleep, when the other thread is in wait queue.

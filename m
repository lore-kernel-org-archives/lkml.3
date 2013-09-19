Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3ISWBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:01:30 -0400
Received: from www17.your-server.de ([213.133.104.17]:57496 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3ISWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:28 -0400
Subject: [PATCH 0/2] Cocci spatch "kzalloc-simple" - v3.11-7547-g44598f9
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604510863-816646221-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/kzalloc-simple.cocci"

Run against version v3.11-7547-g44598f9

Let me know when you as a maintainer are not interested in these kind of patches.
I can exclude you by path; all cocci findings in e.g. "drivers/scsi" will never
be reported again by this semi-automatic cocci program runs.

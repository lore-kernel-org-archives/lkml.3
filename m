Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3ITJur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:50:47 -0400
Received: from www17.your-server.de ([213.133.104.17]:35750 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3ITJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:50:46 -0400
Subject: [PATCH 0/10] Cocci spatch "noderef" - v3.11-7547-g44598f9
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Run against version v3.11-7547-g44598f9

Let me know when you as a maintainer are not interested in these kind of patches.
I can exclude you by path; all cocci findings in e.g. "drivers/scsi" will never
be reported again by this semi-automatic cocci program runs.

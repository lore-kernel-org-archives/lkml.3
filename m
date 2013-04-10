Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932Ab3DJAas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:30:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762821Ab3DJAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:30:46 -0400
From: James M Leddy <james.leddy@canonical.com>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: haitao.zhang@canonical.com
Subject: [PATCH 0/1][RESUBMIT] input: fix weird issue of synaptics psmouse sync lost
Date: Tue,  9 Apr 2013 20:30:42 -0400
Message-Id: <1365553843-11951-1-git-send-email-james.leddy@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been using this patch in Ubuntu kernels for 5 months now
without issue. Since patch author Eric Miao no longer works for us,
I'm sending to the list so that other distros can take advantage of
this.

Last we left off, the suggestion was to make this generic across the
entire range of protocols, not just synaptics. I'm against this for
two reasons. The first is that I don't want to have to ask for
additional testing (I don't have access to the machine). The second
and far more important reason is that I am afraid that this will break
other non-synaptics touchpads, and even though we have a wide range of
hardware, it is impossible to guarantee that it'll work on everything
out there. I will do it however if it's the way we need to go with
this.

Please let me know what you think, or if you need any additional
information or testing.

James M Leddy (1):
  input: fix weird issue of synaptics psmouse sync lost
    after resume

 drivers/input/mouse/synaptics.c |    2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.9.5


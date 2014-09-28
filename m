Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaI1XJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 19:09:52 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:64231 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaI1XJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 19:09:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-kernel@vger.kernel.org
Message-id: <fb54b1e8bb54.5428953e@langara.bc.ca>
Date: Sun, 28 Sep 2014 23:09:50 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Does inotify work with special files such as
 /proc/<pid>/task/<tid>/children?
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I can't seem to get inotify to work with special files such as
/proc/<pid>/task/<tid>/children? I just need to get a simple yes/no
answer on whether it works for special files or whether I have to try
a different approach.

Thank you,
Steven Stewart-Gallus

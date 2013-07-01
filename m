Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3GASTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:19:36 -0400
Received: from relay.parallels.com ([195.214.232.42]:50931 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3GASTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:19:35 -0400
Message-ID: <51D1C826.3030902@parallels.com>
Date: Mon, 1 Jul 2013 22:19:18 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: CRIU <criu@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: [Announce] Checkpoint-restore tool v0.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.211.120.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone!

Yes, it's that time again! As the Linux-v3.10 is out, we're releasing
the criu-v0.6 to catch up with the recent kernel changes. These includes
posix cpu timers, pending signals and netlink sockets.

As for other new cool features and changes, please visit the
http://criu.org/Download/criu/0.6

Stay tuned!

Thanks,
Pavel

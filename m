Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3JRQzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:55:24 -0400
Received: from relay.parallels.com ([195.214.232.42]:60705 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3JRQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:55:20 -0400
Message-ID: <526167F5.1050906@parallels.com>
Date: Fri, 18 Oct 2013 20:55:17 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: CRIU <criu@openvz.org>, Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Announceme] Checkpoint-restore tool v0.8
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everyone!

I'm glad to announce the 8th release of the checkpoint-restore tool.
Though it was mostly bugfix release, we have added a couple of new
features.

You can find the changelog at http://criu.org/Download/criu/0.8
and get the sourced from http://download.openvz.org/criu/criu-0.8.tar.bz2

It doesn't require any _new_ kernel stuff, so you can run it on v3.11.

Have fun!

Thanks,
Pavel

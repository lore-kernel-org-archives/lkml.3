Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BTLS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:18:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29611 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142Ab3BTLS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:18:58 -0500
Message-ID: <5124B107.1040302@parallels.com>
Date: Wed, 20 Feb 2013 15:18:31 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        CRIU <criu@openvz.org>
Subject: [Announce] Checkpoint-restore tool v0.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everyone!

As was planned, the v0.4 of C/R tools is out, right after the Linux v3.8.

The most valuable thing in this release, is that all the kernel patches
we had are now merged, and thus what crtools-v0.4 can do will work on
the upstream kernel (properly configured)!

Another notable feature is that crtools is no longer the x86_64-only tool :)
We've done initial support for the ARM architecture and ready to go on
with that.

More info about the release is available on

	http://criu.org/Download/crtools/0.4


Have fun!

Thanks,
Pavel

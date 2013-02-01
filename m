Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3BAUT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:19:56 -0500
Received: from plane.gmane.org ([80.91.229.3]:44314 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab3BAUTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:19:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Eric Appleman <erappleman@gmail.com>
Subject: [BUG] Rate control regression for Intel Wireless 6230 with 3.8 kernel
Date: Fri, 1 Feb 2013 20:14:56 +0000 (UTC)
Message-ID: <loom.20130201T211208-272@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 98.113.39.171 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20130119 Firefox/20.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 11n mode is enabled, speed begins to throttle once the connection is
stressed by a speed test or download.

3.7: 84Mbps/40
3.8: 3Mbps/1

If you need logs, I uploaded them on Launchpad.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1103314


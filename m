Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3DUJxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:53:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48968 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3DUJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:53:29 -0400
From: dmitry pervushin <dmitry.pervushin@linaro.org>
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: patches@linaro.org
Subject: [PATCH 0/2]  netfilter: idletimers
Date: Sun, 21 Apr 2013 11:53:12 +0200
Message-Id: <1366537994-19511-1-git-send-email-dmitry.pervushin@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

[PATCH 1/2] netfilter: idletimers - fix the case of already expired timer
[PATCH 2/2] netfilter: idletimers - add send_nl_msg field

These two patches fix the case of already expired timer and add capability to send netlink message notifications in addition to sysfs notifications (previous serie was started here: http://article.gmane.org/gmane.linux.kernel/1362838)


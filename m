Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaGOV6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:58:12 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:59733 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbaGOV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:57:07 -0400
Message-Id: <20140715215451.499191426@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 16 Jul 2014 01:54:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 0/4] timerfd c/r support, v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry for spamming, but in v4 I simply messed up in the series,
doing reply-to-reply with updated variants. So here are all patches
up to date on top of -rc5. Sorry again for resend.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaAHU0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:26:01 -0500
Received: from plane.gmane.org ([80.91.229.3]:50091 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbaAHUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:25:57 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: rh_ <richard_hubbe11@lavabit.com>
Subject: 3.13-rc7 Oops in kernel/timer.c:1084 on ARM
Date: Wed, 8 Jan 2014 12:20:30 -0800
Organization: L2N
Message-ID: <20140108122030.384d2542968726863e296a49@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip70-185-179-134.sb.sd.cox.net
User-Agent: dsodnetnin
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
X-NNTP-Posting-Host: 192.168.1.1
Mail-Copies-To: never
X-Archive: expiry=79
X-Mailer: EZnn0.37u
X-Newsreader: EZnn0.37u
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was logged in via a serial and lost the output but I recall this much:

While doing a halt (or reboot, forget which), saw this:

timer.c:1084:BUG_ON(tbase_get_base(timer->base) != base);

Do not see this in 3-13-rc2

model name      : ARMv7 Processor rev 2 (v7l)
Features        : swp half thumb fastmult vfp edsp neon vfpv3 tls vfpd32 
Hardware        : Generic AM33XX (Flattened Device Tree)


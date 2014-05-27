Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaE0Vmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:42:33 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:58359 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaE0VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:39:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] tlan: Link handling improvements and Olicom fixes
Date: Tue, 27 May 2014 23:38:38 +0200
Message-Id: <1401226727-5508-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series improves link handling in tlan driver, allowing the
cable to be (un)plugged anytime and NetworkManager to work properly.

Also there are some bugfixes related to Olicom OC-2326 card.
But one bug remains: packet loss at 10 Mbps under load. As wireshark shows,
the card does not transmit some of the packets. Everything seems to be fine
from driver's view - can't figure out where the problem is.

-- 
Ondrej Zary


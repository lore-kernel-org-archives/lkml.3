Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935834AbaBDWWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:22:50 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:56839 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933903AbaBDWWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:22:45 -0500
Message-ID: <1391552562.13156.14.camel@x220>
Subject: [PATCH 0/2] raw: two issues with the handling of the max minor
 number
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Feb 2014 23:22:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2014 22:22:42.0721 (UTC) FILETIME=[9F1DE910:01CF21F7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed some issues with the way the raw driver sets its maximum minor
number and how that driver tests against that maximum. These two small
patches try to correct these issues.

The Kconfig change was tested with make menuconfig only. The change to
the actual code was compile tested only!

Paul Bolle (2):
  raw: test against runtime value of max_raw_minors
  raw: set range for MAX_RAW_DEVS

 drivers/char/Kconfig | 1 +
 drivers/char/raw.c   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaBLKSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:18:39 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50417 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaBLKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:18:34 -0500
Message-ID: <1392200311.23759.27.camel@x220>
Subject: blackfin: Kconfig symbol VIDEO_MT9M114?
From: Paul Bolle <pebolle@tiscali.nl>
To: Sonic Zhang <sonic.zhang@analog.com>, Steven Miao <realmz6@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 11:18:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 10:18:32.0752 (UTC) FILETIME=[C838CB00:01CF27DB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, Sonic,

Your commit 54e4ff4d4024 ("blackfin: adi gpio driver and pinctrl driver
support") added a check for the Kconfig macro CONFIG_VIDEO_MT9M114. That
commit was added during the v3.13 release cycle.

There's no Kconfig symbol VIDEO_MT9M114 in mainline. And it doesn't look
like this was a typo. So why was that check added?

Regards,


Paul Bolle


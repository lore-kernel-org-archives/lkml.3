Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbbATIqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:46:46 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:60689 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbbATIqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:46:45 -0500
Message-ID: <1421743602.9655.83.camel@x220>
Subject: staging: fbtft: CONFIG_ARCH_BCM2708?
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Noralf Tronnes <notro@tronnes.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 09:46:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2015 08:46:43.0491 (UTC) FILETIME=[9DB8C730:01D0348D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Noralf, 

Your commit c296d5f9957c ("staging: fbtft: core support") is included in
today's linux-next (ie, next-20150120). I noticed because a script I use
to check linux-next spotted a problem in it.

See, that commit adds two checks for CONFIG_ARCH_BCM2708. But there's no
Kconfig symbol ARCH_BCM2708. (A comment in
drivers/mmc/host/sdhci-bcm2835.c does suggest there's an out of tree
"Main bcm2708 linux port".)

Is the code to add the Kconfig symbol ARCH_BCM2708 queued somewhere?

Thanks,


Paul Bolle


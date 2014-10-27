Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaJ0Jyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:54:45 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63386 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbaJ0Jyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:54:44 -0400
Message-ID: <1414403681.28499.4.camel@x220>
Subject: MIPS: ralink: CONFIG_RALINK_ILL_ACC?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 10:54:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2014 09:54:41.0694 (UTC) FILETIME=[07686BE0:01CFF1CC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Your commit 78865eacb4aa ("MIPS: ralink: add illegal access driver")
landed in today's linux-next (ie, next-20141027). That commit dates back
to May 16, 2013! It adds a driver that is built if CONFIG_RALINK_ILL_ACC
is set. But there's no Kconfig symbol RALINK_ILL_ACC.

I assume that patch that adds this symbol is queued somewhere. Is that
correct?


Paul Bolle


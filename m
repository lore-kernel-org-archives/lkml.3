Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaJ0Kox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:44:53 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56370 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbaJ0Kov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:44:51 -0400
Message-ID: <1414406687.28499.17.camel@x220>
Subject: MIPS: ralink: CONFIG_SOC_MT7621?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 11:44:47 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2014 10:44:48.0270 (UTC) FILETIME=[077782E0:01CFF1D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Your commit 715f2e581856 ("MIPS: ralink: cleanup early_printk") landed
in today's linux-next (ie, next-20141027). It adds two checks for
CONFIG_SOC_MT7621. The patch to add Kconfig symbol SOC_MT7621 is still
pending (see http://patchwork.linux-mips.org/patch/8033/ ).

Obviously, until that patch lands these two checks will always evaluate
to false.


Paul Bolle


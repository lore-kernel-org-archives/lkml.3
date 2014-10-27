Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJ0KGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:06:36 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60006 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbaJ0KGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:06:34 -0400
Message-ID: <1414404391.28499.10.camel@x220>
Subject: MIPS: ralink: CONFIG_SOC_RT2880?
From: Paul Bolle <pebolle@tiscali.nl>
To: John Crispin <blogic@openwrt.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 11:06:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2014 10:06:31.0581 (UTC) FILETIME=[AE8894D0:01CFF1CD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Your commit 0b162e003c2c ("MIPS: ralink: add rt2880 pci driver") landed
in today's linux-next (ie, next-20141027). It adds a check for
CONFIG_SOC_RT2880. But there's no Kconfig symbol SOC_RT2880.

Did you perhaps mean CONFIG_SOC_RT288X here?


Paul Bolle


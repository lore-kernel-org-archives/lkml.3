Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaJ2IVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:21:04 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59458 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbaJ2IU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:20:57 -0400
Message-ID: <1414570854.28499.34.camel@x220>
Subject: CRISv32: ETRAX_SPI_MMC_BOARD
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 09:20:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2014 08:20:55.0280 (UTC) FILETIME=[42A14700:01CFF351]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

Your commit be64c1ce6e79 ("CRISv32: Drop obsolete file for SPI driver")
landed in today's linux-next (ie, next-20141029). It removes the last
user of the Kconfig symbol ETRAX_SPI_MMC_BOARD. Setting that symbol is
now pointless.

Is the trivial patch to remove the entry for ETRAX_SPI_MMC_BOARD (and
one select statement for it) queued somewhere? If not, should I submit
it?


Paul Bolle


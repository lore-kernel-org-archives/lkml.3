Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaKZMZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:25:37 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:39053 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZMZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:25:35 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141122181229.GB9698@katana>
Date: Wed, 26 Nov 2014 15:25:29 +0300
Cc: Stijn Devriendt <highguy@gmail.com>, linux-i2c@vger.kernel.org,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <2A7C987F-15E0-46FD-A711-E7F5BA9893FC@gmail.com>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de> <1416326695-13083-3-git-send-email-wsa@the-dreams.de> <CAOY=C6FSXWn2AKn9gp0oU69U8VkkyJAE7MMUTZsToy0P_Tf6AA@mail.gmail.com> <20141122181229.GB9698@katana>
To: Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


22 нояб. 2014 г., в 21:12, Wolfram Sang <wsa@the-dreams.de> написал(а):

> IMO a repeated start is to ensure that two messages arrive at the slave
> without interruption from another master. I can't think why a slave
> should know which type of start that was. In fact, if it does that would
> raise an eyebrow for me. Do you have an example?

It is used to implement Device ID reading.
Not sure, that the feature is really needed for the first release.

See [1] "3.1.17 Device ID" chapter on page "20 of 64"
See [2] "7.2.2 Device ID (PCA9671 ID field)" chapter

[1] UM10204 I2C-bus specification and user manual (http://www.nxp.com/documents/user_manual/UM10204.pdf)
[2] PCA9671 (http://www.nxp.com/documents/data_sheet/PCA9671.pdf)

Alexander.


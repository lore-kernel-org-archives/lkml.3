Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaL1S5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:57:16 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:33407 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbaL1S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:56:41 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: comedi: checkpatch errors/warnings
Date: Sun, 28 Dec 2014 19:56:12 +0100
Message-Id: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-series will fix checkpatch errors and warnings
which are caused by false spacing and missing blank lines.

It will fix those errors/warnings in drivers/staging/comedi/ and all its
subdirectories. The fixed errors/warnings are:
	WARNING: Missing a blank line after declarations	5 times
	ERROR: trailing whitespace                              once
	ERROR: space prohibited before that ',' (ctx:WxW)       once
	WARNING: please, no space before tabs                   8 times
	ERROR: code indent should use tabs where possible	44 times

After applying the series the following checkpatch errors/warnings will remain
in files in drivers/staging/comedi/ and its subdirectories:
	WARNING: line over 80 characters
	WARNING: quoted string split across lines
	WARNING: break quoted strings at a space character
	WARNING: memory barrier without comment
	WARNING: suspect code indent for conditional statements (x, y)
	WARNING: Use of volatile is usually wrong

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>


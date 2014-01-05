Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaAEMfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:35:14 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:46147 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbaAEMfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:35:11 -0500
X-RRZE-Submit-IP: 62.245.163.133
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        andrea.merello@gmail.com, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com
Subject: [PATCH 0/3] Staging rtl8192e: Fixing several checkpatch errors and warnings
Date: Sun,  5 Jan 2014 13:25:34 +0100
Message-Id: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtllib_crypt_tkip.c we fixed the checkpatch error: space required after that ','.

In rtllib_debug.h we fixed the checkpatch error: Macros with complex values should be enclosed in parenthesis.
We also fixed in rtllib_debug.h the warning, do {} while (0) macros should not be semicolon terminated.
By removing this semicolon we had to fix the wrong use of this macro in rtl8192e/r8192E_phy.c


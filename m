Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaAHWP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:15:56 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36662 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260AbaAHWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:53 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] beeceem: Checkpatch cleanups in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:04 +0100
Message-Id: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series eliminates several issues in InterfaceRx.c of the beeceem driver that have been reported by checkpatch.
The following issues are taken care of:
        - Missing spaces around operators
        - Prohibited spaces before semicolons
        - Missing spaces between function arguments
        - Tab/intendation mishaps
        - Missing spaces at opening parentheses
        - Unwanted newlines before opening braces of conditional statements
        - C99 comments

Lines with lengths over 80 characters still remain.

No functional changes have been made.

-- 
1.8.1.2


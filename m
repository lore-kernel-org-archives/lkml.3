Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3L3LqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:46:05 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44200 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab3L3LqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:46:03 -0500
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: ma.oefelein@arcor.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] beeceem: Several checkpatch cleanups in InterfaceTx.c
Date: Mon, 30 Dec 2013 12:44:20 +0100
Message-Id: <1388403864-19990-1-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some checkpatch issues in InterfaceTx.c which is part of the beeceem driver.
The following errors/warnings have been fixed:
	- prohibited spaces before a (semi)colon
	- missing space before a variable assignment
	- missing spaces between function arguments
	- missing spaces before opening parentheses of if-conditionals
	- unwanted opening braces of if-conditionals in an extra line
	- spaces at the beginning of a line instead of tabs
	- C99-style comments

However, over-80-chars warnings still remain.

This series applies no functional changes to the code whatsoever.

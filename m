Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3A1Qmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:42:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34027 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3A1Qmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:50 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 00/15] Secure boot policy support 
Date: Mon, 28 Jan 2013 11:42:24 -0500
Message-Id: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Secure boot makes it possible to ensure that the on-disk representation of
the kernel hasn't been modified. This can be sidestepped if the in-memory
representation can be trivially altered. We currently have a large number
of interfaces that permit root to perform effectively arbitrary
modifications to the kernel, so this patchset introduces a new capability
("CAP_COMPROMISE_KERNEL") that controls whether or not these features are
available. The aim is for this to be useful in any other situations where
kernel integrity can be assured by some other mechanism rather than special
casing UEFI.


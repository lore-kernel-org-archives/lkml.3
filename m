Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3DOUKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:10:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40553 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3DOUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:10:05 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Fix UEFI variable paranoia 
Date: Mon, 15 Apr 2013 13:09:44 -0700
Message-Id: <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 50.0.250.146
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identical to V5, except with the UCS2 helper functions included this time.


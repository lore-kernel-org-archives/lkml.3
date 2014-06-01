Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaFAQeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:34:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59919 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaFAQeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:34:20 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Date: Sun,  1 Jun 2014 12:33:52 -0400
Message-Id: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-Spam-ASN: 
Subject: ACPI: Improve behaviour on Apple hardware
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:54:46 +0000)
X-SA-Exim-Scanned: Yes (on cavan.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple hardware behaves differently depending on whether or not the OS claims
to be Darwin. Failing to report Darwin results in some hardware being
disabled. However, claiming to be Darwin also alters the behaviour of
battery reporting and PCI handling. These patches add support for reporting
Darwin support and fixing up the behavioural quirks that are exposed as a
result.

-- 
Matthew Garrett | matthew.garrett@nebula.com


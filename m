Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaCKWUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:20:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52139 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbaCKWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:20:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@rjwysocki.net
Subject: Improve ACPI support for Apple hardware 
Date: Tue, 11 Mar 2014 18:19:59 -0400
Message-Id: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various Apple hardware features are disabled unless the OS claims to be
"Darwin" when queried by the firmware, most notably Thunderbolt hotplug
support. This patchset provides support for Darwin at the ACPI layer and
includes a couple of additional fixes to handle issues uncovered by the
change in firmware behaviour.

-- 
Matthew Garrett <matthew.garrett@nebula.com>


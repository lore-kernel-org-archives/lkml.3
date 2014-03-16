Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaCPVlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 17:41:39 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64014 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084AbaCPVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 17:41:38 -0400
Message-ID: <1395006095.2002.8.camel@x41>
Subject: v3.14-rc1+: new error: "nsc-ircc, Wrong chip version ff"
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 22:41:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2014 21:41:36.0648 (UTC) FILETIME=[81BF0880:01CF4160]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

0) Ever since v3.14-rc1 I've noticed two new boot messages on an,
outdated, ThinkPad X41:
    nsc-ircc, Found chip at base=0x164e
    nsc-ircc, Wrong chip version ff

The first is printed at info level, so I would have ignored it, but the
second is printed at error level.

1) I've finally managed to bisect these messages to commit 202317a573b2
("ACPI / scan: Add acpi_device objects for all device nodes in the
namespace"). That's a rather big commit, so I've not even bothered to
try to revert it on top on v3.14-rc6.

2) What should I do to make that error go away?


Paul Bolle


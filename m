Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbaELQnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:43:55 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.113]:32689 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbaELQnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:52 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-5.tower-200.messagelabs.com!1399913022!8210220!32
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
Subject: [PATCH 0/7] staging: unisys: cleanup proc entries in uislib
Date: Mon, 12 May 2014 12:38:28 -0400
Message-ID: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 12 May 2014 16:43:49.0257 (UTC) FILETIME=[597F4790:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes old and redundant proc entries from the uislib
module, and moves the remaining entries to debugfs. The removed entries are
from unit testing of the module and are no longer used. The information in the
vbus directory was redundant, so the directory and entries are removed. The
remaining entries are only interesting when debugging, and are not used by any
user space program, so debugfs is the right place for them.


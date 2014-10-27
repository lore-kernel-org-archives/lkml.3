Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaJ0A5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:57:24 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33361 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJ0A5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:57:23 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] RAS: add the support for handling UCNA/DEFERRED error 
Date: Mon, 27 Oct 2014 08:56:20 +0800
Message-Id: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And on the basis of the first patch, the second patch adds the support
for identifying and handling UCNA/DEFERRED error in machine_check_poll.

[PATCH 1/2] x86, mce, severity: extend the the mce_severity
[PATCH 2/2] x86, mce: support memory error recovery for both UCNA

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaKEEsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:48:39 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55131 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaKEEsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:48:35 -0500
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de, tony.luck@intel.com
Cc: ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2 v2] RAS: add the support for handling UCNA/DEFERRED error
Date: Wed,  5 Nov 2014 12:47:51 +0800
Message-Id: <1415162873-1874-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

At the suggestion of Boris, the first patch extends the mce_severity
mechanism for handling UCNA/DEFERRED error.
  Link: https://lkml.org/lkml/2014/10/23/190

The first patch have also eliminated a big hack to make mce_severity() work
when called from non-exception context on the advice of Tony and Boris.
  Link: https://lkml.org/lkml/2014/10/27/1017

And on the basis of the first patch, the second patch adds the support
for identifying and handling UCNA/DEFERRED error in machine_check_poll.
 
[PATCH 1/2] x86, mce, severity: extend the the mce_severity
[PATCH 2/2] x86, mce: support memory error recovery for both UCNA

thx!
cyc

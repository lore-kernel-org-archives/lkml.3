Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbaFQUFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:05:31 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53822 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:05:26 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: PATCH 0/2 tmon: fix a few minor security issues
Date: Tue, 17 Jun 2014 16:05:07 -0400
Message-Id: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few little fixups for tmon, to prevent abuse of its logging facility

Best
Neil


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaHKD3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:29:05 -0400
Received: from s87.loopia.se ([194.9.94.112]:51842 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaHKD3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:29:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: staging: rtl8192ee: fix %d confusingly prefixed with 0x in format strings
Date: Sun, 10 Aug 2014 20:28:41 -0700
Message-Id: <1407727722-28095-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <20140810042358.GA15249@kroah.com>
References: <20140810042358.GA15249@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending patch based off of
https://kernel.googlesource.com/pub/scm/linux/kernel/git/gregkh/staging


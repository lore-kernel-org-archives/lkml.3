Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3KTHzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:55:23 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60419 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTHzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:55:20 -0500
Date: Wed, 20 Nov 2013 15:53:50 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] staging: et131x: patches for et131x driver
Message-ID: <cover.1384933520.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set should apply to current staging-next tree

ZHAO Gang (5):
  staging: et131x: clean up code
  staging: et131x: drop packet when error occurs in et131x_tx
  staging: et131x: stop read when hit max delay in et131x_phy_mii_read
  staging: et131x: remove spinlock adapter->lock
  staging: et131x: update TODO list

 drivers/staging/et131x/README   |   5 -
 drivers/staging/et131x/et131x.c | 301 +++++++++++++++++-----------------------
 2 files changed, 127 insertions(+), 179 deletions(-)

-- 
1.8.3.1


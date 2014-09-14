Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaINFJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:09:11 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:37180 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaINFJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:09:09 -0400
Date: Sun, 14 Sep 2014 07:09:05 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: Weird character in kernel message
Message-ID: <20140914050905.GA296@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed this today:

Sep 14 06:51:57 x4 kernel: [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec

in hex:
20 01 34 43 45 3A 20

Must be a recent regression.

-- 
Markus

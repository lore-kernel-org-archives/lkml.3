Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaDGRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:49:38 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43083 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDGRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:49:36 -0400
Message-Id: <20140407174701.734703531@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 07 Apr 2014 21:47:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org,
        vdavydov@parallels.com
Subject: [patch 0/3] timerfd -- implement missing parts to checkpoint and restore timerfd state, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is an updated series, changes mostly in show_fdinfo code which now
produces a way more information (and documentation update). Please take a look
once time permit. Thanks!

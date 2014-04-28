Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaD1VdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:33:06 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63495 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbaD1VdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:33:04 -0400
Message-Id: <20140428212517.200264067@openvz.org>
User-Agent: quilt/0.60-1
Date: Tue, 29 Apr 2014 01:25:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org,
        vdavydov@parallels.com
Subject: [patch 0/3] timerfd -- implement missing parts to checkpoint and restore timerfd state, v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello! This is (I hope) the final version. Most changes from v2 are sitting in
documentation, where I tried to reflect that the time we're printing out is
remaining until the timer expiration. Please take a look.

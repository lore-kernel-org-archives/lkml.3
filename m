Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaC1IhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:37:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:48046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaC1Igz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:36:55 -0400
Message-ID: <1395995801.4175.4.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] net/mac80211: Use RCU_INIT_POINTER(x, NULL) in util.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Mar 2014 09:36:41 +0100
In-Reply-To: <1395602503-14958-1-git-send-email-monamagarwal123@gmail.com> (sfid-20140323_202244_669399_5CEA350C)
References: <1395602503-14958-1-git-send-email-monamagarwal123@gmail.com>
	 (sfid-20140323_202244_669399_5CEA350C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, but I rewrote the commit log and squashed the mac80211 patches
into one.

johannes


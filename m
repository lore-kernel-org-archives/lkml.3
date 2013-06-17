Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3FQUoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:44:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57869 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3FQUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:44:32 -0400
X-Nat-Received: from [202.181.97.72]:50297 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1371501858.2924
To: davidlohr.bueso@hp.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] ipc: Avoid sleeping inside RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306170039.GEG18281.MQFtOOSJFOLHVF@I-love.SAKURA.ne.jp>
	<201306172055.GHD65623.LMtVQFHOOFFSOJ@I-love.SAKURA.ne.jp>
	<1371480480.2709.0.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1371480480.2709.0.camel@buesod1.americas.hpqcorp.net>
Message-Id: <201306180544.FDH13067.FFOOtSVQMHFOJL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 18 Jun 2013 05:44:07 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17062013 #10352478, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso wrote:
> This should already be fixed here:
> https://lkml.org/lkml/2013/6/11/705

OK. Please be sure to apply; it is not applied as of 3.10.0-rc6-next-20130617.

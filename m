Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3EOMCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:02:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53058 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab3EOMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:02:40 -0400
X-Nat-Received: from [202.181.97.72]:51111 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368619329.5601
Message-Id: <201305151202.r4FC29c7099530@www262.sakura.ne.jp>
Subject: Re: [3.10-rc1 SLUB?] mm: kmemcheck warning.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: vegardno@ifi.uio.no, penberg@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 15 May 2013 21:02:09 +0900
References: <201305142105.EBE34832.LOOHFtVSFJOFMQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201305142105.EBE34832.LOOHFtVSFJOFMQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 15052013 #9986141, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kmemcheck maintainer, for this might be false positives.

Regarding https://lkml.org/lkml/2013/5/14/248 (this thread) and
https://lkml.org/lkml/2013/5/14/250 (similar one), I tried to run bisection,
but I couldn\'t find the culprit. This problem seems to exist at least since
Linux 3.6. (I couldn\'t test Linux 3.5 and earlier because the kernel dies with
\"divide error\" depending on config/environment).

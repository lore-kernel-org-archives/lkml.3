Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaBYM6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:58:32 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51846 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaBYM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:58:29 -0500
X-Nat-Received: from [202.181.97.72]:51122 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1393333101.17322
To: joe@perches.com, james.l.morris@oracle.com
Cc: takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] security: tomoyo: Use a more current logging style
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <cover.1393279025.git.joe@perches.com>
	<821a3d8fe98a08cbb3fa1be24b083bf1fb6cdc45.1393279025.git.joe@perches.com>
In-Reply-To: <821a3d8fe98a08cbb3fa1be24b083bf1fb6cdc45.1393279025.git.joe@perches.com>
Message-Id: <201402252158.AGC95345.tFQOHVOJSMFLOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 25 Feb 2014 21:58:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25022014 #7301207, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Convert printks to pr_<level>
> Add pr_fmt to prefix output with "tomoyo: "
> Coalesce formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

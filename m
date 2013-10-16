Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072Ab3JPUrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:47:36 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52786 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761784Ab3JPUre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:47:34 -0400
X-Nat-Received: from [202.181.97.72]:51120 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1381956439.24314
To: keescook@chromium.org, james.l.morris@oracle.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130920203556.GA8726@www.outflux.net>
	<alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
	<alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>
	<CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
	<20131016151831.GE5186@outflux.net>
In-Reply-To: <20131016151831.GE5186@outflux.net>
Message-Id: <201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 17 Oct 2013 05:47:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16102013 #11266284, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> Any update on this? It'd be nice to have it in linux-next.

What was the conclusion at LSS about multiple concurrent LSM support?
If we agreed to merge multiple concurrent LSM support, there will be nothing to
prevent this module from merging.

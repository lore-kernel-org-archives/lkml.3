Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3JZNvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64687 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3JZNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:20 -0400
X-Nat-Received: from [202.181.97.72]:56604 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1382795464.11773
To: james.l.morris@oracle.com, jmorris@namei.org, keescook@chromium.org,
        casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20131016151831.GE5186@outflux.net>
	<201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>
	<525F083D.8060502@schaufler-ca.com>
	<CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
	<201310170037.r9H0b6jT024903@www262.sakura.ne.jp>
In-Reply-To: <201310170037.r9H0b6jT024903@www262.sakura.ne.jp>
Message-Id: <201310262251.IFB56202.HSFOOtFMVOFLQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 26 Oct 2013 22:51:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 26102013 #10892478, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> I would send another one which uses only security_file_alloc/free .

I sent it to James, Casey and Kees on "Fri, 18 Oct 2013 22:56:19 +0900" and
waiting for your response. How long are we expected to remain vulnerable due to
lack of multiple concurrent LSM support?

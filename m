Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533Ab3JQAhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:37:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64647 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383Ab3JQAhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:37:22 -0400
X-Nat-Received: from [202.181.97.72]:61733 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1381970226.31395
Message-Id: <201310170037.r9H0b6jT024903@www262.sakura.ne.jp>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: keescook@chromium.org
Cc: james.l.morris@oracle.com, jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au,
        casey@schaufler-ca.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 17 Oct 2013 09:37:06 +0900
References: <20130920203556.GA8726@www.outflux.net> <alpine.LRH.2.02.1309241124420.3782@tundra.namei.org> <alpine.LRH.2.02.1309241128430.3782@tundra.namei.org> <CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com> <20131016151831.GE5186@outflux.net> <201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp> <525F083D.8060502@schaufler-ca.com> <CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
In-Reply-To: <CAGXu5jLSDynZ_XRZGZ+0uZTgtygO1n8+3rOnR+WonH5-tkui6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16102013 #11266284, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> So I sent this LSM as one I\'d been waiting
> for stacking on. Essentially, I\'m breaking the catch-22 by sending
> this. I\'d like it to get into the tree so we don\'t have a catch-22
> about stacking any more. :)

I\'m also trying to break the catch-22 by sending KPortReserve.
I would send another one which uses only security_file_alloc/free .

> The core changes first, and the userspace interface changes next?

I welcome that approach, for none of such single function LSM modules
depends on userspace interface changes.

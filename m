Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaAMMrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:47:31 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58311 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaAMMr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:47:28 -0500
X-Nat-Received: from [202.181.97.72]:51499 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389617170.32502
To: miklos@szeredi.hu, viro@ZenIV.linux.org.uk,
        linux-security-module@vger.kernel.org
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/11] cross rename v3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
Message-Id: <201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 13 Jan 2014 21:46:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13012014 #7314088, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Please consider for -next (3.14).

Excuse me, but did you explain to CONFIG_SECURITY_PATH=y users?
I don't see changes in TOMOYO and AppArmor directories.
TOMOYO might want to use new keyword like "file swapname"
rather than using "file rename" for cross rename operation.

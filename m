Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3JKWgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:36:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59384 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab3JKWgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:36:18 -0400
X-Nat-Received: from [202.181.97.72]:58455 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1381530968.9307
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [ 29/39] kernel/kmod.c: check for NULL in call_usermodehelper_exec()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20131011193210.843963685@linuxfoundation.org><20131011193214.042998813@linuxfoundation.org>
In-Reply-To: <20131011193214.042998813@linuxfoundation.org>
Message-Id: <201310120731.CFE57348.tHQFOOLVMFFSJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 12 Oct 2013 07:36:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11102013 #11204819, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.

3.0-stable doesn't need this patch because commit 264b83c07a84
("usermodehelper: check subprocess_info->path != NULL") already fixed it.

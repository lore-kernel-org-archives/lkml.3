Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3BCS7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 13:59:18 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:40434 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3BCS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 13:59:16 -0500
Date: Sun, 3 Feb 2013 19:59:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] asmlinkage tag for sys_iopl
Message-ID: <20130203185912.GA22895@gmail.com>
References: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Artem Savkov <artem.savkov@gmail.com> wrote:

> asmlinkage tag seems to be missing from sys_iopl prototype rendering iopl
> syscalls unusable, i.e. every call returns -EINVAL. Most likely introduced in
> 9e0b2428bc6a6c6df90bb701ca843820727cadf0.

What commit is 9e0b2428bc6a6c6df90bb701ca843820727cadf0? It's 
certainly not upstream nor in the x86 tree.

Thanks,

	Ingo

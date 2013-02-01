Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3BAHf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:35:29 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53466 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3BAHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:35:24 -0500
MIME-Version: 1.0
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
Date: Fri, 1 Feb 2013 09:35:22 +0200
X-Google-Sender-Auth: 9gkV3FsLsBt19s7-X0FGXtURf4w
Message-ID: <CAOJsxLFxmW674R2shbj0s0Jy9hBjM5ob5QwaEbJw3O9+FtTUyw@mail.gmail.com>
Subject: Re: [PATCH 0/7] liblock: userspace lockdep
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 6:47 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> This patch series adds a userspace lock correctnes validator into
> tools/lib/liblock.
>
> There are no changes to any kernel code whatsoever, lockdep is
> being used as is.
>
> First 6 patches are the liblock implementation, the last one is
> an example of liblock being used on an existing codebase.

This is awesome, Sasha! For the whole series:

Acked-by: Pekka Enberg <penberg@kernel.org>

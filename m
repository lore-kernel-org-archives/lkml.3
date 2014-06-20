Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaFTQD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:03:56 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42617 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaFTQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <53A3C177.1000905@zytor.com>
References: <1403230336-10444-1-git-send-email-yinghai@kernel.org>
	<53A3B8B7.70806@zytor.com>
	<CAE9FiQXRWR8vWFZEsuoGMbe1mZL72QWyjWfNt13o0+Q9bgHJfg@mail.gmail.com>
	<53A3C177.1000905@zytor.com>
Date: Fri, 20 Jun 2014 09:03:54 -0700
X-Google-Sender-Auth: 4N7Sn9sugDA7YJ5AuXS-jdjUJQc
Message-ID: <CAE9FiQUcpHJPzbN5t3bHYCQUcRtdP_EB0J7UhKcfU9j6M5agmA@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Support initrd that is bigger then 2G.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> For each of those transfers, we don't free the source memory until the
> very end.  We could free that memory as we process the input, requiring
> less total memory.

Yes, that would be nice enhancement.

Yinghai

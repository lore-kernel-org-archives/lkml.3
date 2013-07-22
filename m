Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3GVE0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 00:26:47 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43648 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3GVE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 00:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <f7c9193e244c95122ceb47d65cd52993c040c7a4.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
	<f7c9193e244c95122ceb47d65cd52993c040c7a4.1374451988.git.joe@perches.com>
Date: Mon, 22 Jul 2013 09:56:45 +0530
Message-ID: <CAKohponxfLpf66QgF=K0c0EGhQyXVazqQk-2Ecw1YeRAY5VY2w@mail.gmail.com>
Subject: Re: [PATCH 05/18] MAINTAINERS: ARM: spear: Consolidate sections
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2013 05:45, Joe Perches <joe@perches.com> wrote:
> commit a7ed099ffc8 ("ARM: spear: move all files to mach-spear")
> moved all the files into a single directory, delete the now
> unnecessary duplicate sections and update the pattern.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Arnd Bergmann <arnd@arndb.de>
> cc: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  MAINTAINERS | 30 +-----------------------------
>  1 file changed, 1 insertion(+), 29 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

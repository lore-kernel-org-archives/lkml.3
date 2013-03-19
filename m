Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3CSMh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:37:56 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40644 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3CSMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:37:55 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.17.83]
In-Reply-To: <1360496352-29482-2-git-send-email-sjur.brandeland@stericsson.com>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com> <1360496352-29482-2-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 19 Mar 2013 14:37:33 +0200
Message-ID: <CAK=WgbYpTkjPsPRHO8is60SM-JR-LLCt8GK43mDAyBvt8EZP9w@mail.gmail.com>
Subject: Re: [PATCH 1/9] remoteproc: Bugfix: Deallocate firmware image on shutdown
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Sun, Feb 10, 2013 at 1:39 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
>
> Fixes coherent memory leakage, caused by non-deallocated
> firmware image chunk.

I'll just slightly edit the subject + commit log to indicate this fix
is STE-specific.

> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>

Can I add your s-o-b here?

Since you sent the patch, we should add your s-o-b after Dmitry's.

Thanks,
Ohad.

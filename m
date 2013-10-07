Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3JGGMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:12:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54848 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3JGGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <1381040600-12683-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381040600-12683-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 7 Oct 2013 11:42:18 +0530
Message-ID: <CA+V-a8tn54CcaFEBMM48GMnTuG=OhQtxm7=od_4OZm6Xo_S9qA@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 11:53 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regrads,
--Prabhakar Lad

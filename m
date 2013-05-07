Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab3EGBsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:48:50 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34537 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3EGBst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <1367889447-15619-3-git-send-email-chao.xie@marvell.com>
References: <1367889447-15619-1-git-send-email-chao.xie@marvell.com>
	<1367889447-15619-3-git-send-email-chao.xie@marvell.com>
Date: Tue, 7 May 2013 09:48:47 +0800
Message-ID: <CAN1soZxQQTQG1CdNGYmCDfddLHWA5HVZ+SWjFhcfidsdGazprw@mail.gmail.com>
Subject: Re: [PATCH 2/2] rtc: pxa: add pxa95x rtc support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: xie chao <xiechao.mail@gmail.com>, Linux Russell <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leo Song <liangs@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 9:17 AM, Chao Xie <chao.xie@marvell.com> wrote:
> the pxa95x rtc need access PBSR register before write to RTTR, RCNR, RDCR, and RYCR registers.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---

Do we really need this for other SoC? PXA95x is removed already since
it's a block on supporting
multi-platform & not used widely.

Regards
Haojian

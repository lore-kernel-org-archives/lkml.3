Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaLRBUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:20:38 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48455 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaLRBUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:20:37 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v7 1/3] Input: add regulator haptic driver
Date: Wed, 17 Dec 2014 17:20:33 -0800
Message-ID: <1633066.YGSdCsNTgy@dtor-glaptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-40-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <54922B36.8050306@samsung.com>
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com> <20141217220602.GC32399@dtor-ws> <54922B36.8050306@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 10:17:42 AM Jaewon Kim wrote:
> Hi Dmity,
> 
> 2014년 12월 18일 07:06에 Dmitry Torokhov 이(가) 쓴 글:
> > HI Jaewon,
> > 
> > On Wed, Dec 17, 2014 at 12:35:06PM +0900, Jaewon Kim wrote:
> >> This patch adds support for haptic driver controlled by
> >> voltage of regulator. And this driver support for
> >> Force Feedback interface from input framework
> >> 
> >> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> >> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
> >> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > 
> > Does the driver still work if you apply the patch below on top of yours?
> > 
> > Thanks.
> 
> Yes, there is no problem to apply this one first.

Thank you. Then I'll fold it into yours and queue the driver for the next 
release.

Thanks.

-- 
Dmitry

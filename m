Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaILGno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:43:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36264 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaILGnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:43:42 -0400
Date: Thu, 11 Sep 2014 23:43:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 2/4] Input: misc: Add haptic driver on max77693
Message-ID: <20140912064337.GB31165@core.coreip.homeip.net>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-3-git-send-email-jaewon02.kim@samsung.com>
 <20140911171002.GC13083@core.coreip.homeip.net>
 <54124EA1.8060507@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54124EA1.8060507@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:38:41AM +0900, Jaewon Kim wrote:
> Hello Dmity Torokhov.
> 
> 2014년 09월 12일 02:10에 Dmitry Torokhov 이(가) 쓴 글:
> >On Thu, Sep 11, 2014 at 09:54:20PM +0900, Jaewon Kim wrote:
> >>This patch add max77693-haptic device driver to support the haptic controller
> >>on MAX77693. The MAX77693 is a Multifunction device with PMIC, CHARGER, LED,
> >>MUIC, HAPTIC and the patch is haptic device driver in the MAX77693. This driver
> >>support external pwm and LRA(Linear Resonant Actuator) motor. User can control
> >>the haptic driver by using force feedback framework.
> >>
> >>Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> >>Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> >Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >
> >How do we want to merge this?
> >
> thanks for review.
> 
> Please merge this input device patch only.
> Another patchs will be merged by lee jones.

Queued fro the next merge window (with some minor edits).

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaIKRKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:10:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63505 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaIKRKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:10:08 -0400
Date: Thu, 11 Sep 2014 10:10:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 2/4] Input: misc: Add haptic driver on max77693
Message-ID: <20140911171002.GC13083@core.coreip.homeip.net>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-3-git-send-email-jaewon02.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410440062-19963-3-git-send-email-jaewon02.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:54:20PM +0900, Jaewon Kim wrote:
> This patch add max77693-haptic device driver to support the haptic controller
> on MAX77693. The MAX77693 is a Multifunction device with PMIC, CHARGER, LED,
> MUIC, HAPTIC and the patch is haptic device driver in the MAX77693. This driver
> support external pwm and LRA(Linear Resonant Actuator) motor. User can control
> the haptic driver by using force feedback framework.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

How do we want to merge this?

-- 
Dmitry

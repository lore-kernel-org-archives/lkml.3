Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaGDKKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:10:05 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:50042 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaGDKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:10:03 -0400
Date: Fri, 4 Jul 2014 12:10:00 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Hyogi Gim <hyogi.gim@lge.com>
Cc: John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [rtc-linux] [PATCH] drivers/rtc/interface.c: check the error
 after __rtc_read_time()
Message-ID: <20140704121000.608901c9@linux.lan.towertech.it>
In-Reply-To: <1404436946-28354-1-git-send-email-hyogi.gim@lge.com>
References: <1404436946-28354-1-git-send-email-hyogi.gim@lge.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Jul 2014 10:22:26 +0900
Hyogi Gim <hyogi.gim@lge.com> wrote:

> In __rtc_set_alarm(), the error after __rtc_read_time() is not checked.
> If rtc device fail to read time, we cannot guarantee the following process.
> 
> Add the verification code for returned __rtc_read_time() error.
> 
> Signed-off-by: Hyogi Gim <hyogi.gim@lge.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


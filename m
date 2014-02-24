Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaBXLkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:40:08 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36792 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaBXLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:40:06 -0500
Date: Mon, 24 Feb 2014 11:39:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH v4 00/36] mtd: st_spi_fsm: Add new driver
Message-ID: <20140224113956.GA12186@lee--X1>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
 <20140108143316.GA14575@lee--X1>
 <20140122125049.GA8586@lee--X1>
 <20140123014613.GX8919@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123014613.GX8919@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> > Can you confirm receipt of this set, or would you like me to resend?
> 
> Well, I personally have the patch set but haven't had a chance to review
> it. Can you resend with MTD in the CC, since we haven't had any comments
> anyway? I believe MTD people are much less likely to look at it if you
> forget the CC :)
> 
> You can just title it [PATCH RESEND v4 X/Y], possibly with a LKML
> link back to the original v4, if you want to help avoid confusion.

I did as you asked, received feedback and resent with all feedback
tended to. v5 has been on the MLs for just under a week now. There
doesn't seem to be any more concerns with the driver.

Would you be kind enough to Ack the series. On receipt I can knock a
pull-request together for you.

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

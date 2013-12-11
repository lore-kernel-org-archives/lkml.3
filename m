Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab3LKItE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:49:04 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:57298 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3LKItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:49:02 -0500
Date: Wed, 11 Dec 2013 08:48:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>, angus.clark@st.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20131211084856.GF2390@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-2-git-send-email-lee.jones@linaro.org>
 <20131210204635.GD27149@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131210204635.GD27149@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

Thank you for taking the time to review, it's very much appreciated.
You bought out some interesting points that I'm happy to go away and
rectify. Firstly however, as I inherited this code I'd like to give
Angus a chance to comment before we go off on our own tangent and
rework some of the good code which perhaps should remain unchanged.

Angus, do you have enough time to go through Brian's review comments
and perhaps reply to the ones that you feel would benefit from your
expert knowledge. To be frank, some of the questions that were asked I
wouldn't be able to answer without your guidance in any case.

Thanks both.

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

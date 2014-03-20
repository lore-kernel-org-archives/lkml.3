Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbaCTMDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:03:14 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34874 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbaCTMDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:03:13 -0400
Date: Thu, 20 Mar 2014 12:03:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from function
 arguments
Message-ID: <20140320120307.GA9240@lee--X1>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
 <1395314713.7776.17.camel@joe-AO722>
 <20140320114123.GE21349@lee--X1>
 <1395316090.7776.24.camel@joe-AO722>
 <20140320115412.GU31517@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140320115412.GU31517@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good catch. That wasn't my intention.

+1

> > Why?

An oversight.

> I can let Lee speak for himself. But I'm thinking I'll squash this diff
> in, if no one minds:
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>

Patch looks good to me:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

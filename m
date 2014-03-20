Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaCTLlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:41:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64846 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:41:29 -0400
Date: Thu, 20 Mar 2014 11:41:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, kernel@stlinux.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com
Subject: Re: [PATCH 1/5] mtd: st_spi_fsm: Remove useless consts from function
 arguments
Message-ID: <20140320114123.GE21349@lee--X1>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
 <1395313907-25318-2-git-send-email-lee.jones@linaro.org>
 <1395314713.7776.17.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395314713.7776.17.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014, Joe Perches wrote:

> On Thu, 2014-03-20 at 11:11 +0000, Lee Jones wrote:
> > Reported-by: Brian Norris <computersforpeace@gmail.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Why are these useless?
> 
> Even if the object code produced is the same,
> these serve as information to the human reader
> about how the arguments are used.

https://lkml.org/lkml/2014/3/20/69

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaEWLns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:43:48 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62651 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWLnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:43:47 -0400
Date: Fri, 23 May 2014 12:43:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: axp20x: Remove unnecessary const qualifier from
 axp20x_supplies[]
Message-ID: <20140523114341.GX19747@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
 <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
 <1400774373.21099.1.camel@joe-AO725>
 <20140522160856.GJ19747@lee--X1>
 <1400777136.21099.6.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400777136.21099.6.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > To be frank, I've never known what the double const means.  Care to
> > enlighten?
> 
> There's a nice table here:
> 
> http://stackoverflow.com/questions/14562845/why-does-passing-char-as-const-char-generate-a-warning

Okay, I get it. I think you're right, I'll make the change and see
what else breaks and try to fix that too.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

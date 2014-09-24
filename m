Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaIXMNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:13:33 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64603 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaIXMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:13:32 -0400
Date: Wed, 24 Sep 2014 13:13:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jared_Dominguez@DELL.com
Cc: chris@printf.net, micky_ching@realsil.com.cn, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: rtsx_pcr: Fix MSI enable error handling
Message-ID: <20140924121326.GD32069@lee--X1>
References: <868ulz1i2e.fsf@void.printf.net>
 <20140908145801.GF30307@lee--X1>
 <28616F4740DDF542AA1DB7C9F597963907BA109F6F@AUSX7MCPS301.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28616F4740DDF542AA1DB7C9F597963907BA109F6F@AUSX7MCPS301.AMER.DELL.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Jared_Dominguez@DELL.com wrote:

> Thank you. Could you send the patch for inclusion in the 3.17 kernel since it's solely a bug fix?

I'm afraid this is not going to be possible anymore.  Linus is opening
the merge-window early this cycle.  I'll ensure Stable is CC'ed.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

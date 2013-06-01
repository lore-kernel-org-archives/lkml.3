Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3FAEAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:00:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44388 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3FAEAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:00:45 -0400
Date: Fri, 31 May 2013 21:00:46 -0700
From: Olof Johansson <olof@lixom.net>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 2/3] ARM: SAMSUNG: Consolidate uncompress subroutine
Message-ID: <20130601040046.GB3868@quad.lixom.net>
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
 <1370000944-19786-3-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370000944-19786-3-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 05:19:03PM +0530, Tushar Behera wrote:
> For mach-exynos, uart_base is a pointer and the value is calculated
> in the machine folder. For other machines, uart_base is defined as
> a macro in platform directory. For symmetry, the uart_base macro
> definition is removed and the uart_base calculation is moved to
> specific machine folders.
> 
> This would help us consolidating uncompress subroutine for s5p64x0.

Sorry, reading these in order and didn't go through all of them.

Same comment here, you can use config_enabled() and return early instead of
adding ifdefs.


-Olof

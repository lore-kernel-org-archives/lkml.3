Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936351Ab3DIUwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:52:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:53551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762739Ab3DIUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:52:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="225224674"
Date: Tue, 9 Apr 2013 22:52:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mfd: syscon: fix warnings when printing resource_size_t
Message-ID: <20130409205216.GB24058@zurbaran>
References: <1365529802-17844-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365529802-17844-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tue, Apr 09, 2013 at 09:50:02PM +0400, Alexander Shiyan wrote:
> Gets rid of these warnings when compile module for 64 bit targets:
>   CC      drivers/mfd/syscon.o
>   drivers/mfd/syscon.c: In function 'syscon_probe':
>   drivers/mfd/syscon.c:155:2: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]
>   drivers/mfd/syscon.c:155:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/syscon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

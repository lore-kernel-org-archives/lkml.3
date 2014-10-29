Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaJ2GXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:23:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:63697 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaJ2GXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:23:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="598135722"
Date: Wed, 29 Oct 2014 11:12:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [alsa-devel] [PATCH 01/11] MAINTANERS: Add AXD as a supported
 driver
Message-ID: <20141029054252.GX28745@intel.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
 <1414495589-8579-2-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414495589-8579-2-git-send-email-qais.yousef@imgtec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:26:19AM +0000, Qais Yousef wrote:
> AXD is Audio Processing IP driver that will be added in the following commits

This should be after the addition of files, so last patch pls

-- 
~Vinod
> 
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <alsa-devel@alsa-project.org>
> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dab92a78d1d5..b42c7386190e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1826,6 +1826,12 @@ F:	include/uapi/linux/ax25.h
>  F:	include/net/ax25.h
>  F:	net/ax25/
>  
> +AXD AUDIO PROCESSING IP DRIVER
> +M:	Qais Yousef <qais.yousef@imgtec.com>
> +S:	Supported
> +F:	Documentation/devicetree/bindings/axd.txt
> +F:	drivers/char/axd/
> +
>  AZ6007 DVB DRIVER
>  M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
>  L:	linux-media@vger.kernel.org
> -- 
> 2.1.0
> 
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel

-- 

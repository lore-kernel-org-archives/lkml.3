Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3CUOSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:18:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43227 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758354Ab3CUOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:18:42 -0400
Date: Thu, 21 Mar 2013 14:18:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "haojian.zhuang@linaro.org" <haojian.zhuang@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 01/11] OF: add empty of_device_is_available for !OF
Message-ID: <20130321141812.GG15279@e106331-lin.cambridge.arm.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
 <1363820051-24428-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363820051-24428-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 10:54:01PM +0000, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add an empty version of of_device_is_available.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  include/linux/of.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index a0f1292..6fe655b 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -379,6 +379,11 @@ static inline int of_device_is_compatible(const struct device_node *device,
>  	return 0;
>  }
>  
> +static inline int of_device_is_available(const struct device_node *device,)

I assume that comma shouldn't be there?                                     ^

Mark.

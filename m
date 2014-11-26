Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaK0CbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:31:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaK0CbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:31:02 -0500
Date: Wed, 26 Nov 2014 15:27:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Konopko <kris@konagma.com>
Cc: navin.patidar@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] rtl8188eu:  Remove leading spaces in rtw_led.c
Message-ID: <20141126232719.GA12287@kroah.com>
References: <1415316268-10278-1-git-send-email-kris@konagma.com>
 <1415316268-10278-2-git-send-email-kris@konagma.com>
 <1415316268-10278-3-git-send-email-kris@konagma.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415316268-10278-3-git-send-email-kris@konagma.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:24:28AM +0100, Krzysztof Konopko wrote:
> According to Linux coding convention leading spaces are not allowed.  This
> patch removes leading spaces in rtw_led.c
> 
> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
> ---
>  drivers/staging/rtl8188eu/core/rtw_led.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
> index 1b8264b..5d7e8ec 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_led.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_led.c
> @@ -40,6 +40,7 @@ void BlinkTimerCallback(void *data)
>  void BlinkWorkItemCallback(struct work_struct *work)
>  {
>  	struct LED_871x *pLed = container_of(work, struct LED_871x, BlinkWorkItem);
> +
>  	BlinkHandler(pLed);
>  }

This is not a "fix leading space" change :(

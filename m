Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbbAYQXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:23:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbbAYQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:24 -0500
Date: Sun, 25 Jan 2015 19:39:59 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: mathieu.poirier@linaro.org
Cc: forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: vt6655: correcting function declaration
 sparse error
Message-ID: <20150125113959.GA22997@kroah.com>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
 <1421546666-21461-2-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421546666-21461-2-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 07:04:23PM -0700, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
>   LD      drivers/staging/vt6655/built-in.o
>   CHECK   drivers/staging/vt6655/device_main.c
> drivers/staging/vt6655/device_main.c:1672:5: warning: symbol 'vnt_init' was not declared. Should it be static?
>   CC [M]  drivers/staging/vt6655/device_main.o
> 
> Function @vnt_init is only called by @vt6655_probe, in turn is declared "static".
> As sparse suggest, @vnt_init should very likely be declared static as well.  At
> least nothing in the file indicate that it should be otherwise.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/staging/vt6655/device_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This whole series does not apply to my staging-next branch, of
staging.git, please refresh against it and resend if it is still needed
(hint, I don't think they all are...)

thanks,

greg k-h

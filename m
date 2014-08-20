Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaHTLuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:50:51 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43248 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaHTLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:50:48 -0400
Message-ID: <53F48B94.9090002@cogentembedded.com>
Date: Wed, 20 Aug 2014 15:50:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com
Subject: Re: [PATCH v4 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
References: <1408513585-28261-1-git-send-email-r.baldyga@samsung.com> <1408513585-28261-3-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1408513585-28261-3-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 8/20/2014 9:46 AM, Robert Baldyga wrote:

> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> returns endpoint descriptor to userspace. It works only if function
> is active.

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

[...]

> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
> index 0154b28..900896e 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -265,6 +265,12 @@ struct usb_functionfs_event {
>    */
>   #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
>
> +/*
> + * Returns endpoint descriptor. In funciton is not active returns -ENODEV.

    s/funciton/function/.

WBR, Sergei


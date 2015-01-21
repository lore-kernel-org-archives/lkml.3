Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbbAUL4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:56:01 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44498 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbAULzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:55:44 -0500
Message-ID: <54BF93BC.2000804@cogentembedded.com>
Date: Wed, 21 Jan 2015 14:55:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Peter Hung <hpeter@gmail.com>, johan@kernel.org
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v2 4/4] usb: serial: remove unused function for F81232
References: <1421836221-25619-1-git-send-email-hpeter+linux_kernel@gmail.com>
In-Reply-To: <1421836221-25619-1-git-send-email-hpeter+linux_kernel@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/21/2015 1:30 PM, Peter Hung wrote:

> remove unused function set_line_control

    The source says set_control_lines().

> Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
> ---
>   drivers/usb/serial/f81232.c | 7 -------
>   1 file changed, 7 deletions(-)

> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index 9a54f56..11a236b 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
> @@ -323,13 +323,6 @@ static void f81232_process_read_urb(struct urb *urb)
>   		tty_flip_buffer_push(&port->port);
>   	}
>
> -
> -}
> -
> -static int set_control_lines(struct usb_device *dev, u8 value)
> -{
> -	/* FIXME - Stubbed out for now */
> -	return 0;
>   }
>
>   static void f81232_break_ctl(struct tty_struct *tty, int break_state)

WBR, Sergei


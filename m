Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaEGRt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:49:28 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56217 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEGRtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:49:24 -0400
Message-ID: <5369C37A.1000001@gmail.com>
Date: Wed, 07 May 2014 07:24:10 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
CC: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] MAINTAINERS: Add linux-api for review of API/ABI changes
References: <20140506205953.GA16997@jtriplet-mobl1>
In-Reply-To: <20140506205953.GA16997@jtriplet-mobl1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 10:59 PM, Josh Triplett wrote:
> This makes it more likely that patch submitters will CC API/ABI changes
> to the linux-api list, and tools like get_maintainer.pl will do so
> automatically.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Every little bit helps, I guess. However, what I think would make a difference
is if if people constantly posted reminders to CC linux-api when they see API/API
changes on the lists. (And the reminders should of course CC linux-api).

Acked-by: Michael Kerrisk <mtk.man-pages@gmail.com>

> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7578deb..52a282b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -210,6 +210,13 @@ S:	Supported
>  F:	Documentation/scsi/aacraid.txt
>  F:	drivers/scsi/aacraid/
>  
> +ABI/API
> +L:	linux-api@vger.kernel.org
> +F:	Documentation/ABI/
> +F:	include/linux/syscalls.h
> +F:	include/uapi/
> +F:	kernel/sys_ni.c
> +
>  ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
>  M:	Hans de Goede <hdegoede@redhat.com>
>  L:	lm-sensors@lm-sensors.org
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

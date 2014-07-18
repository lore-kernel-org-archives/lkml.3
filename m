Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549AbaGRPTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:19:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465AbaGRPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:19:22 -0400
Message-ID: <53C93AF8.5090407@infradead.org>
Date: Fri, 18 Jul 2014 08:19:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH/linux-next] Documentation:Docbook: Fix file locations
 in gadget.tmpl
References: <1405655169-23804-1-git-send-email-standby24x7@gmail.com> <1405655169-23804-2-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1405655169-23804-2-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 08:46 PM, Masanari Iida wrote:
> Because of file location changes by commit 5ed4ac73e5975,
> make xmldocs failed because of missing files.
> Fix file paths in gadget.tmpl file.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Hi,

There was a patch for this on the USB mailing list yesterday
from Andrzej Pietrasiewicz <andrzej.p@samsung.com>.

Hopefully Felipe or Greg will apply one of them soon.

Thanks.

> ---
>  Documentation/DocBook/gadget.tmpl | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/gadget.tmpl b/Documentation/DocBook/gadget.tmpl
> index 2c425d7..6416292 100644
> --- a/Documentation/DocBook/gadget.tmpl
> +++ b/Documentation/DocBook/gadget.tmpl
> @@ -556,11 +556,11 @@ been converted to this framework.
>  Near-term plans include converting all of them, except for "gadgetfs".
>  </para>
>  
> -!Edrivers/usb/gadget/f_acm.c
> -!Edrivers/usb/gadget/f_ecm.c
> -!Edrivers/usb/gadget/f_subset.c
> -!Edrivers/usb/gadget/f_obex.c
> -!Edrivers/usb/gadget/f_serial.c
> +!Edrivers/usb/gadget/function/f_acm.c
> +!Edrivers/usb/gadget/function/f_ecm.c
> +!Edrivers/usb/gadget/function/f_subset.c
> +!Edrivers/usb/gadget/function/f_obex.c
> +!Edrivers/usb/gadget/function/f_serial.c
>  
>  </sect1>
>  
> 


-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbbAGGvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:51:04 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:49385 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAGGvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:51:03 -0500
Date: Wed, 7 Jan 2015 07:50:55 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v2 24/40] avr32: whitespace fix
Message-ID: <20150107065055.GA18142@samfundet.no>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-25-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-25-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 06 Jan 2015 17:44:50 +0200 or thereabout, Michael S. Tsirkin wrote:
> Align using tabs to make code prettier.
>

It is already aligned using tabs, but there is one too much. Thanks for
cleaning.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/include/asm/uaccess.h b/arch/avr32/include/asm/uaccess.h
> index ccd07c4..72607f3 100644
> --- a/arch/avr32/include/asm/uaccess.h
> +++ b/arch/avr32/include/asm/uaccess.h
> @@ -278,7 +278,7 @@ extern int __put_user_bad(void);
>  				       __pu_err);			\
>  			break;						\
>  		case 8:							\
> -			__put_user_asm("d", __pu_addr, __pu_val,		\
> +			__put_user_asm("d", __pu_addr, __pu_val,	\
>  				       __pu_err);			\
>  			break;						\
>  		default:						\
-- 
mvh
Hans-Christian Egtvedt

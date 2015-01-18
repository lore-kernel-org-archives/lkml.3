Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbbARNJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:09:53 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58800 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbbARNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:09:50 -0500
X-Sasl-enc: FIZS/Czc82fFbhbEsGhxNzJx09aQOHI8PQd+v+H4jplH 1421586589
Message-ID: <54BBB09C.6010206@imap.cc>
Date: Sun, 18 Jan 2015 14:09:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, hjlipp@web.de
CC: isdn@linux-pingi.de, gigaset307x-common@lists.sourceforge.ne,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn:gigaset:Remove unneeded TODO comment for the function,gigaset_procinfo
 in capi.c
References: <1421519027-22410-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1421519027-22410-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.01.2015 um 19:23 schrieb Nicholas Krause:
> This removes the no longer needed TODO comment for questioning if
> the function,gigaset_procinfo needs to do more work internally. This
> comment is no longer needed due to the function's intended use to be
> returning the name of the structure pointer passed to this function
> of type,capi_ctr. In addition due to this the function's comments
> related to it's intended job are changed to state it returns rather
> then builds the description for the structure and also that the
> function doesn't build the name string but returns the already
> generated one passed to gigaset_procinfo by the structure passed
> to this function.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks,
Tilman

> ---
>  drivers/isdn/gigaset/capi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index ccec777..c4d666e 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -2336,14 +2336,14 @@ static u16 gigaset_send_message(struct capi_ctr *ctr, struct sk_buff *skb)
>  }
>  
>  /**
> - * gigaset_procinfo() - build single line description for controller
> + * gigaset_procinfo() - return single line description for controller
>   * @ctr:	controller descriptor structure.
>   *
> - * Return value: pointer to generated string (null terminated)
> + * Return value: pointer to already generated string (null terminated)
>   */
>  static char *gigaset_procinfo(struct capi_ctr *ctr)
>  {
> -	return ctr->name;	/* ToDo: more? */
> +	return ctr->name;
>  }
>  
>  static int gigaset_proc_show(struct seq_file *m, void *v)
> 

-- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)

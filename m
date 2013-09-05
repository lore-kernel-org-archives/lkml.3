Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763282Ab3IEDFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:05:34 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63563 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3IEDFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:05:32 -0400
Message-ID: <5227F4F8.8080406@lwfinger.net>
Date: Wed, 04 Sep 2013 22:05:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, gregkh@linuxfoundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: staging/rtl8188eu: pass channel list by reference instead of
 copying struct.
References: <20130904234539.GA11208@redhat.com>
In-Reply-To: <20130904234539.GA11208@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 06:45 PM, Dave Jones wrote:
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
> index 8b2ba26..4b2eb8e 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
> @@ -1827,13 +1827,13 @@ unsigned int OnAction_back(struct adapter *padapter, union recv_frame *precv_fra
>
>   #ifdef CONFIG_88EU_P2P
>
> -static int get_reg_classes_full_count(struct p2p_channels channel_list)
> +static int get_reg_classes_full_count(struct p2p_channels *channel_list)
>   {

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

GregKH might want a [PATCH] in the subject, but the content of this patch is OK.

Thanks,

Larry



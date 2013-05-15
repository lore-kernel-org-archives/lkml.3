Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3EONVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:21:35 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47716 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3EONVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:21:34 -0400
Message-ID: <51938BDD.8080301@cogentembedded.com>
Date: Wed, 15 May 2013 17:21:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Schmiedl Christian <Christian.Schmiedl@gemalto.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
Subject: Re: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN Interface
References: <376FB829F3ECB542B825EAF4D8CA8A97012A57999273@CROEXCFWP03.gemalto.com>
In-Reply-To: <376FB829F3ECB542B825EAF4D8CA8A97012A57999273@CROEXCFWP03.gemalto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-05-2013 16:28, Schmiedl Christian wrote:

> /drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface
> by adding QMI_FIXED_INTF with Cinterion's Vendor ID as well as Product ID and
> WWAN Interface Number.

> Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel <at> gemalto.com>
> Signed-off-by: Christian Schmiedl <christian.schmiedl <at> gemalto.com>
> ---
> patch is against linux-3.9
> --- linux-3.9/drivers/net/usb/qmi_wwan.c.orig	2013-05-06 08:10:11.170034451 +0200
> +++ linux-3.9/drivers/net/usb/qmi_wwan.c	2013-05-06 08:58:00.800264179 +0200
>   <at>  <at>  -569,6 +569,7  <at>  <at>  static const struct usb_device_id produc

    Your patch is corrupt. From the "<at>  <at>" it seems the corruptor 
was gmane. :-)

WBR, Sergei


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3CYRJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:09:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53922 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209Ab3CYRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:09:33 -0400
Date: Mon, 25 Mar 2013 13:09:24 -0400 (EDT)
Message-Id: <20130325.130924.1771800578429290181.davem@davemloft.net>
To: josright123@gmail.com
Cc: wfp5p@virginia.edu, matthew@mattleach.net, gregkh@linuxfoundation.org,
        joseph_chang@davicom.com.tw, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ethernet driver: dm9000: davicom: Upgrade the
 driver to suit for all DM9000 series chips
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364198682-1589-1-git-send-email-josright123@gmail.com>
References: <1364198682-1589-1-git-send-email-josright123@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 25 Mar 2013 10:09:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph CHANG <josright123@gmail.com>
Date: Mon, 25 Mar 2013 16:04:42 +0800

>  #define CARDNAME	"dm9000"
> -#define DRV_VERSION	"1.31"
> +/* [KERN-ADD-1](upgrade) */
> +#define DRV_VERSION	"1.39"
 ...
> +			/* [KERN-ADD-2] */

These kinds of comments are absolutely inapproprate.

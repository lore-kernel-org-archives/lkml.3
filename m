Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbbAZXxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:53:25 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204AbbAZXxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:53:23 -0500
Message-ID: <54C6D36F.1090509@nod.at>
Date: Tue, 27 Jan 2015 00:53:19 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        =?ISO-8859-15?Q?Guido_Mart=EDnez?= <guido@vanguardiasur.com.ar>
Subject: Re: [PATCH 1/2 v2] UBI: Add initial support for scatter gather
References: <1420926734-16417-1-git-send-email-richard@nod.at>
In-Reply-To: <1420926734-16417-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.01.2015 um 22:52 schrieb Richard Weinberger:
> Adds a new set of functions to deal with scatter gather.
> ubi_eba_read_leb_sg() will read from a LEB into a scatter gather list.
> The new data structure struct ubi_sgl will be used within UBI to
> hold the scatter gather list itself and metadata to have a cursor
> within the list.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Can I please get a Reviewed-by for this patch?

Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3H2SDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:03:00 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:22567 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3H2SC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:02:58 -0400
Message-ID: <521F8CCE.2010508@tilera.com>
Date: Thu, 29 Aug 2013 14:02:54 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: add null check for kzalloc in tile/kernel/setup.c
References: <52156E0B.7020705@gmail.com>
In-Reply-To: <52156E0B.7020705@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2013 9:49 PM, Wang Sheng-Hui wrote:
> Should check the return value of kzalloc first to avoid the null pointer.
> Then can dereference the non-null pointer to access the fields of struct resource.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  arch/tile/kernel/setup.c |    4 ++++
>  1 file changed, 4 insertions(+)

Thanks.  Taken into the tile tree.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

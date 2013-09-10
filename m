Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3IJCDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:03:33 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37564 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3IJCDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:03:32 -0400
Date: Mon, 09 Sep 2013 21:03:28 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] doc: fix some typos in documentation
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: benh@kernel.crashing.org, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
In-Reply-To: <5228786E.1030501@huawei.com> (from qiuxishi@huawei.com on Thu
	Sep  5 07:26:22 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378778608.8385.17@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 07:26:22 AM, Xishi Qiu wrote:
> Fix some typos in  
> Documentation/IRQ-domain.txt/email-clients.txt/io-mapping.txt
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  Documentation/IRQ-domain.txt    |    4 ++--
>  Documentation/email-clients.txt |    2 +-
>  Documentation/io-mapping.txt    |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/IRQ-domain.txt  
> b/Documentation/IRQ-domain.txt
> index 9bc9594..5a8b8ed 100644
> --- a/Documentation/IRQ-domain.txt
> +++ b/Documentation/IRQ-domain.txt
> @@ -97,7 +97,7 @@ hwirq number.  The disadvantage is that hwirq to  
> IRQ number lookup is
>  dependent on how many entries are in the table.
> 
>  Very few drivers should need this mapping.  At the moment, powerpc
> -iseries is the only user.
> +series is the only user.

That one's not a typo, there actually was a powerpc iseries:

http://lxr.free-electrons.com/source/arch/powerpc/platforms/iseries/setup.c?v=2.6.35

It got removed in the past year or so (git bisect could find the  
commit), which implies that this documentation needs to be fixed if  
this removed architecture was the only user of whatever it's  
documenting. (Ping the powerpc guys?)

Rob
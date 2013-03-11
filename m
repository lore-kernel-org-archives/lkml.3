Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3CKT3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:29:12 -0400
Received: from bitmer.com ([213.157.87.50]:55500 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:29:11 -0400
X-Greylist: delayed 2703 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 15:29:11 EDT
Message-ID: <513E25E3.5050907@bitmer.com>
Date: Mon, 11 Mar 2013 20:43:47 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: linux-omap@vger.kernel.org, peter.ujfalusi@ti.com, lgirdwood@gmail.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap: convert to devm_ioremap_resource()
References: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 03/11/2013 05:58 PM, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  sound/soc/omap/omap-dmic.c  |    9 +++------
>  sound/soc/omap/omap-mcpdm.c |    8 +++-----
>  2 files changed, 6 insertions(+), 11 deletions(-)
> 
Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>

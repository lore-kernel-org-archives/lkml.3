Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab3HNQtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:49:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37373 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab3HNQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:49:38 -0400
Message-ID: <520BB51F.5000707@wwwdotorg.org>
Date: Wed, 14 Aug 2013 10:49:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/29] tegra: simplify use of devm_ioremap_resource
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr> <1376471493-22215-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376471493-22215-7-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 03:11 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.

I believe that drivers/iommu changes are usually applied by Joerg Roedel
<joro@8bytes.org> and drivers/memory changes by Greg Kroah-Hartman
<gregkh@linuxfoundation.org>, although admittedly neither of those is
particularly called out by the MAINTAINERS file...

I guess these are simple enough that I can take them through the Tegra
tree though, since it doesn't look like there will be any conflicts
doing so for 3.12.

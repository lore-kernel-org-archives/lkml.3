Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3HOWHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:07:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41336 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3HOWHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:07:52 -0400
Message-ID: <520D5135.7020503@wwwdotorg.org>
Date: Thu, 15 Aug 2013 16:07:49 -0600
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

I have applied this to Tegra's for-3.12/cleanup branch.

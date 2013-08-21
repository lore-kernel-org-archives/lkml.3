Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3HUR0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:26:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab3HUR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:26:46 -0400
Message-ID: <5214F853.20200@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:26:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 1/2] pinctrl: utils : add support to pass config type
 in generic util APIs
References: <1377084218-13858-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377084218-13858-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 05:23 AM, Laxman Dewangan wrote:
> Add support to pass the config type like GROUP or PIN when using
> the utils or generic pin configuration APIs. This will make the
> APIs more generic.
> 
> Added additional inline APIs such that it can be use directly as
> callback for the pinctrl_ops.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>


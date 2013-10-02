Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3JBQLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:11:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51780 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3JBQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:11:34 -0400
Message-ID: <524C45B3.8010109@wwwdotorg.org>
Date: Wed, 02 Oct 2013 10:11:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org, heiko@sntech.de
Subject: Re: [PATCH] pinctrl: palmas: remove pin config BIAS_PULL_PIN_DEFAULT
 support
References: <1380713832-24488-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380713832-24488-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 05:37 AM, Laxman Dewangan wrote:
> Palmas devices do not support the default bias configuration
> and hence removing this option from valid pin config parameters.

Acked-by: Stephen Warren <swarren@nvidia.com>

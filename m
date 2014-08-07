Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaHGR1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:27:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53810 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaHGR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:27:21 -0400
Message-ID: <53E3B700.8080706@wwwdotorg.org>
Date: Thu, 07 Aug 2014 11:27:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v5 6/6] clk: Add floor and ceiling constraints to clock
 rates
References: <1407333368-31979-1-git-send-email-tomeu.vizoso@collabora.com> <1407333368-31979-6-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1407333368-31979-6-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 07:56 AM, Tomeu Vizoso wrote:
> Adds a way for clock consumers to set maximum and minimum rates. This can be
> used for thermal drivers to set ceiling rates, or by misc. drivers to set
> floor rates to assure a minimum performance level.

Patches 5, 6,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

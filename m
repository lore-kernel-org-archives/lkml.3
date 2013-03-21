Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3CUR3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:29:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39935 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3CUR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:29:51 -0400
Message-ID: <514B438B.80603@wwwdotorg.org>
Date: Thu, 21 Mar 2013 11:29:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, swarren@nvidia.com,
        Graeme Gregory <gg@slimlogic.co.uk>, Ian Lartey <ian@slimlogic.co.uk>,
        "J, KEERTHY" <j-keerthy@ti.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] gpio: palmas: add dt support
References: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363876214-25933-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 08:30 AM, Laxman Dewangan wrote:
> Add of_device_id table for Palma GPIO to be enable the
> driver from DT file.

On this, the RTC patches, and the regulator patches, I think you should
be Ccing the Slimlogic guys (CC'd now) and perhaps some people from TI
(CC'd now; I hope the right people) , to make sure so that you're all on
the same page w.r.t. how the DT bindings work, and so you don't step on
each-others toes.

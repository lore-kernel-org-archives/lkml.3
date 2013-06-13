Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3FMTjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:39:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38852 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3FMTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:39:21 -0400
Message-ID: <51BA1FE7.4000900@wwwdotorg.org>
Date: Thu, 13 Jun 2013 13:39:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 01:59 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This document snippet tries to be helpful and define the pin
> PM states and helpers, and how they should be used to create
> some kind of common ontology around this.

Oops. I haven't been keeping up well. I propose we hold off on this
patch for a short while until the other thread on this topic is finalized.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3HNUNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:13:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58236 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3HNUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:12:59 -0400
Message-ID: <520BE4C7.9020101@wwwdotorg.org>
Date: Wed, 14 Aug 2013 14:12:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH v2] pinctrl: improve warning messages
References: <1376506966-11623-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1376506966-11623-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 01:02 PM, Linus Walleij wrote:
> Print out the affected group name on activation of pin mux
> settings, and warn if you cannot free a pin that should have
> been part of a certain setting.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

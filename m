Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3FFQHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:07:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45868 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3FFQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:07:40 -0400
Message-ID: <51B0B3C9.1030409@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:07:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add pinconf-generic define for a pin-default
 pull
References: <201306061644.26078.heiko@sntech.de>
In-Reply-To: <201306061644.26078.heiko@sntech.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:44 AM, Heiko Stübner wrote:
> There exist controllers that don't support to set the pull to up or down
> separately but instead automatically set the pull direction based on
> embedded knowledge inside the controller, for example depending on the
> selected mux function of the pin.
> 
> Therefore this patch adds another config option to use this default
> pull-state for a pin where it is not possible to know or decide if the
> pin will be pulled up or down.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

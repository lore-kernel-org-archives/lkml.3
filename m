Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3FXSEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:04:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49647 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3FXSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:04:44 -0400
Message-ID: <51C88A39.3040201@wwwdotorg.org>
Date: Mon, 24 Jun 2013 12:04:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        =?UTF-8?B?77+9?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com> <51C2F7BE.2060805@imgtec.com> <51C4A447.3090807@wwwdotorg.org> <3185376.o7RqphCDfQ@avalon>
In-Reply-To: <3185376.o7RqphCDfQ@avalon>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 05:30 PM, Laurent Pinchart wrote:
> Hi Stephen,
> 
> On Friday 21 June 2013 13:06:47 Stephen Warren wrote:
...
>> IIRC the idea of the PULL_PIN_DEFAULT was to avoid having to specify
>> UP/DOWN for each pin/group, but could just say "default", which would
>> then reduce the number of pinctrl mapping table entries or pinctrl DT
>> property entries.
> 
> I may be mistaken, but I've understood the PULL_PIN_DEFAULT option as a way to 
> select the default bias configuration when the default value is hardware-
> controlled, not as a pure software option.

That's my understanding too.



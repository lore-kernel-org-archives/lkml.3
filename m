Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3BSQre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:47:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55866 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab3BSQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:47:33 -0500
Message-ID: <5123ACA1.9000408@wwwdotorg.org>
Date: Tue, 19 Feb 2013 09:47:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Having slew rate settings for other
 than SM0/1 is not fatal
References: <1361015443.11226.1.camel@phoenix>
In-Reply-To: <1361015443.11226.1.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2013 04:50 AM, Axel Lin wrote:
> Ignore the setting and show "Only SM0/SM1 can set slew rate" warning is enough,
> then we can return 0 instead of -EINVAL in tps6586x_regulator_set_slew_rate().
> 
> Otherwise, probe() fails.

Why does probe() fail; what is trying to set a slew rate on a regulator
that doesn't support it? At least a few days ago in linux-next, this
patch wasn't needed AFAIK. Is the problem something new?


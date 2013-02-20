Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3BTHNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:13:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59728 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab3BTHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:13:05 -0500
Message-ID: <5124777F.9050309@wwwdotorg.org>
Date: Wed, 20 Feb 2013 00:13:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: Use dev_err rather than dev_warn
 for error message
References: <1361327026.9733.1.camel@phoenix>
In-Reply-To: <1361327026.9733.1.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 07:23 PM, Axel Lin wrote:
> tps6586x_regulator_set_slew_rate() returns -EINVAL when having slew rate
> settings for other than SM0/1, thus use dev_err rather than dev_warn.

Reviewed-by: Stephen Warren <swarren@nvidia.com>


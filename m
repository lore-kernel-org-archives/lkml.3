Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3IRP0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:26:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49982 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3IRP0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:26:46 -0400
Message-ID: <5239C634.5020102@nvidia.com>
Date: Wed, 18 Sep 2013 09:26:44 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, rob.herring@calxeda.com, mark.rutland@arm.com,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH V4] regulator: core: add support for configuring turn-on
 time through constraints
References: <1379508482-10550-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379508482-10550-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 06:48 AM, Laxman Dewangan wrote:
> The turn-on time of the regulator depends on the regulator device's
> electrical characteristics. Sometimes regulator turn-on time also
> depends on the capacitive load on the given platform and it can be
> more than the datasheet value.
> 
> The driver provides the enable-time as per datasheet.
> 
> Add support for configure the enable ramp time through regulator
> constraints so that regulator core can take this value for enable
> time for that regulator.

The binding,
Acked-by: Stephen Warren <swarren@nvidia.com>

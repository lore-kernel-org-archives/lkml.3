Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3IJReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:34:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56263 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3IJReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:34:17 -0400
Message-ID: <522F5815.4070109@wwwdotorg.org>
Date: Tue, 10 Sep 2013 11:34:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com,
        mark.rutland@arm.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com> <1378811888-2268-2-git-send-email-ldewangan@nvidia.com> <522F3691.3090805@wwwdotorg.org> <20130910165153.GQ29403@sirena.org.uk>
In-Reply-To: <20130910165153.GQ29403@sirena.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 10:51 AM, Mark Brown wrote:
> On Tue, Sep 10, 2013 at 09:11:13AM -0600, Stephen Warren wrote:
> 
>>> +- regulator-enable-time: Turn ON time for regulator(in uS)
> 
>> Bike-shedding slightly: This isn't really the time it takes to
>> enable a regulator, but the time the voltage takes to become
>> stable, or settle. Perhaps name the property
>> regulator-settle-time/regulator-settle-delay?
> 
> The normal term would be ramp delay.  It's not usually the time
> taken to completely settle, it's usually quoted as the time taken
> to reach within some proportion of the target voltage.

I notice there's a regulator-ramp-delay property, already documented
right above this new property. Is this a conflicting usage of the same
term, or should that existing property just be used in this case too?

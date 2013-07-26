Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3GZQmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:42:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57918 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3GZQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:42:51 -0400
Message-ID: <51F2A706.9080005@wwwdotorg.org>
Date: Fri, 26 Jul 2013 10:42:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, akpm@linux-foundation.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        gg@slimlogic.co.uk, kishon@ti.com, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com> <51F2985F.60202@wwwdotorg.org> <20130726163528.GS9858@sirena.org.uk>
In-Reply-To: <20130726163528.GS9858@sirena.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 10:35 AM, Mark Brown wrote:
> On Fri, Jul 26, 2013 at 09:40:15AM -0600, Stephen Warren wrote:
> 
>> Given there's only 1 battery, I think "back-" is redundant in
>> the property names. Since that shortens the names a bit, I'd
>> suggest spelling everything out in full, perhaps:
> 
> Isn't there an integrated charger on the PMIC?  If there is then
> it's useful to identify which is being talked about (even if it
> should be relatively obvious).

Oh yes, that's probably true. This is of course the binding for the
RTC sub-module in the PMIC though.


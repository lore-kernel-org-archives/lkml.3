Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab3BTSAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:00:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46056 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3BTSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:00:06 -0500
Message-ID: <51250F22.8050401@wwwdotorg.org>
Date: Wed, 20 Feb 2013 11:00:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com> <5123C18A.9010604@wwwdotorg.org> <5124C18F.6070108@nvidia.com> <20130220131112.GE2726@opensource.wolfsonmicro.com> <5124CEF5.3060605@nvidia.com> <512506F9.2030508@wwwdotorg.org> <20130220173109.GU2726@opensource.wolfsonmicro.com> <512509A9.6020208@wwwdotorg.org> <20130220175721.GW2726@opensource.wolfsonmicro.com>
In-Reply-To: <20130220175721.GW2726@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 10:57 AM, Mark Brown wrote:
> On Wed, Feb 20, 2013 at 10:36:41AM -0700, Stephen Warren wrote:
>> On 02/20/2013 10:31 AM, Mark Brown wrote:
> 
>>> Since we can extend the list of clocks it doesn't seem like
>>> there's much issue here, especially if some of them are
>>> optional?
> 
>> Yes, there's certainly a way to extend the binding in a 
>> backwards-compatible way.
> 
>> However, I have seen in Rob and/or Grant push back on not fully 
>> defining bindings in the past - i.e. actively planning to
>> initially create a minimal binding and extend it in the future,
>> rather than completely defining it up-front.
> 
> That sounds like the current stuff with a minimal definition is
> OK?

I'm personally OK with defining a minimal binding first and extending
it later. But, I'm worried if when we actually try to extend the
binding later, we'll get push-back.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaGaUhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:37:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaGaUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:37:03 -0400
Message-ID: <53DAA8E6.3010400@suse.de>
Date: Thu, 31 Jul 2014 22:36:54 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/4] ARM: dts: Add exynos5250-spring device tree
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-5-git-send-email-afaerber@suse.de> <53DA936E.9060004@gmail.com>
In-Reply-To: <53DA936E.9060004@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.07.2014 21:05, schrieb Tomasz Figa:
>> +	};
>> +
>> +	fixed-rate-clocks {
>> +		xxti {
>> +			compatible = "samsung,clock-xxti";
>> +			clock-frequency = <24000000>;
>> +		};
>> +	};
> 
> This is also referencing a node from higher level, so it should be done
> using a reference.

Actually this one isn't! Neither fixed-rate-clocks nor xxti exists in
the .dtsi.

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg

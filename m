Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3IPE2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:28:42 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18767 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3IPE2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:28:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 15 Sep 2013 21:25:24 -0700
Message-ID: <523688FB.2010701@nvidia.com>
Date: Mon, 16 Sep 2013 12:28:43 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378985061-28547-1-git-send-email-wni@nvidia.com> <1378985061-28547-4-git-send-email-wni@nvidia.com> <5231D709.5080308@wwwdotorg.org>
In-Reply-To: <5231D709.5080308@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:00 PM, Stephen Warren wrote:
> On 09/12/2013 05:24 AM, Wei Ni wrote:
>> Add OF document for LM90 in Documentation/devicetree/.
> 
>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
> 
>> +Optional properties:
>> +- vcc-supply: vcc regulator for the supply voltage.
>> +              If this is not set, assuming vcc is always powered.
> 
> I thought that was going to be a "Required Property".

There may have many platforms without regulator, they always power on
this device, so how can they set this "vcc-supply "property if we set it
as "Required Property".
Set to dummy-regulator? but it seems the regulator framework can't
handle it yet.

Wei.

> 


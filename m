Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3IKJjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:39:39 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10487 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IKJji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:39:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Sep 2013 02:39:37 -0700
Message-ID: <52303A88.5050306@nvidia.com>
Date: Wed, 11 Sep 2013 17:40:24 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <20130909135022.GZ29403@sirena.org.uk> <20130909155043.GA18975@roeck-us.net> <20130909160237.GR29403@sirena.org.uk> <20130909161735.GC18975@roeck-us.net> <20130909203910.GV29403@sirena.org.uk> <522E9A85.9050803@nvidia.com> <522EA51C.90706@roeck-us.net> <522EB0AF.9030708@nvidia.com> <20130910101359.GX29403@sirena.org.uk> <522F02A4.7060702@nvidia.com> <20130910121157.GJ29403@sirena.org.uk>
In-Reply-To: <20130910121157.GJ29403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 08:11 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Sep 10, 2013 at 07:29:40PM +0800, Wei Ni wrote:
> 
>> On my platform, it use palmas-regulator.c, ldo6 for this lm90 power
>> rail. I checked this driver, it will handle ramp_delay except LDOx.
>> Since I'm not familiar with this palmas device and driver, so do you
>> mean I can set regulator-ramp-delay property in the DT for ldo6, but I
>> really don't know what value should I set :(
> 
> Laxman just submitted a patch adding the ramp delay information which I
> applied.  It seems like this is just a hack for your board and can
> therefore be removed?

Oh, yes, it seems the patches is Laxman's [PATCH 1/2] regulator: palmas:
configure enable time for LDOs.
Thanks, I will check it, and remove the delay in my next patch.

Wei.

> 
> * Unknown Key
> * 0x7EA229BD
> 


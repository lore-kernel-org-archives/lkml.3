Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3IJEZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:25:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18917 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab3IJEZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:25:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Sep 2013 21:25:06 -0700
Message-ID: <522E9F4E.2060109@nvidia.com>
Date: Tue, 10 Sep 2013 12:25:50 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com> <522E489D.6080903@wwwdotorg.org> <20130909222330.GA31708@roeck-us.net>
In-Reply-To: <20130909222330.GA31708@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 06:23 AM, Guenter Roeck wrote:
> On Mon, Sep 09, 2013 at 04:15:57PM -0600, Stephen Warren wrote:
>> On 09/09/2013 04:29 AM, Wei Ni wrote:
>>> Add OF document for LM90 in Documentation/devicetree/.
>>
>>> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt
>>> b/Documentation/devicetree/bindings/hwmon/lm90.txt
>>
>>> +Optional properties:
>>
>>> +- interrupts: Contains a single interrupt specifier which
>>> describes the +              LM90 pin6 output.
>>
>> Does the pin also have a standard name you could include here, rather
>> than (or in addition to) just the pin number?
>>
> This is the "ALERT" pin (or maybe "-ALERT" to reflect that it is low-active).

Thanks, Guenter, I will update it.
> 
> Guenter
> 


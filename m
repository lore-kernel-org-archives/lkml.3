Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaA1Cdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:33:45 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58744 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA1Cdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:33:43 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E71708.7010607@roeck-us.net>
Date: Mon, 27 Jan 2014 18:33:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wei Ni <wni@nvidia.com>,
        linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
References: <20140126211357.6fa68909@endymion.delvare> <52E573B6.9040903@roeck-us.net> <20140126214936.7736f530@endymion.delvare> <52E58330.90602@roeck-us.net> <52E58656.7000903@roeck-us.net> <20140126235103.GP11727@sirena.org.uk> <52E6951C.60609@wwwdotorg.org> <20140127185031.GA28910@roeck-us.net> <20140127230447.7e8be3a4@endymion.delvare> <20140127234135.GA18059@roeck-us.net> <20140127235815.GA8513@sirena.org.uk>
In-Reply-To: <20140127235815.GA8513@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 03:58 PM, Mark Brown wrote:
> On Mon, Jan 27, 2014 at 03:41:35PM -0800, Guenter Roeck wrote:
>
>> I'll test Mark's two patches on my system and let you know the results.
>> After looking some more into it, those _may_ actually fix the problem at least
>> for systems supporting ACPI. No promise, though, and I am not sure if that
>> would be sufficient (it may still not work on non-ACPI PCs). But then who
>
> They should fix ACPI systems, if they don't we need to fix them further
> - that case should just work, it was an oversight not to have a patch
> like the ACPI one in already.  I'm not sure how many non-ACPI PCs still
> exist, we're definitely talking about things over 10 years old (even
> before PCs became ACPI only they started to have ACPI present which
> should be sufficient).
>
> Jean, I'm doing a writeup but it's probably not going to be done today.
>

I confirmed that your two patches ("regulator: core: Correct default
return value for full constraints" and "ACPI: Flag use of ACPI and ACPI
idioms for power supplies to regulator API") together fix the problem
with the lm90 driver, at least for ACPI based systems.

Thanks,
Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3IPEVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:21:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13084 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3IPEVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:21:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 15 Sep 2013 21:18:35 -0700
Message-ID: <52368762.7000701@nvidia.com>
Date: Mon, 16 Sep 2013 12:21:54 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] hwmon: (lm90) Add power control
References: <1378985061-28547-1-git-send-email-wni@nvidia.com> <1378985061-28547-2-git-send-email-wni@nvidia.com> <20130912115106.GM29403@sirena.org.uk>
In-Reply-To: <20130912115106.GM29403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 07:51 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Sep 12, 2013 at 07:24:19PM +0800, Wei Ni wrote:
> 
>> +#include <linux/delay.h>
> 
> You don't need this any more, otherwise

Oh, yes, I will remove it.

> 
> Reviewed-by: Mark Brown <broonie@linaro.org>
> 
> * Unknown Key
> * 0x7EA229BD
> 


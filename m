Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3GII7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:59:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2787 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3GII7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:59:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Jul 2013 01:59:35 -0700
Message-ID: <51DBD0CB.2000504@nvidia.com>
Date: Tue, 9 Jul 2013 16:58:51 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [lm-sensors] [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for
 lm90
References: <1372928979-26938-1-git-send-email-wni@nvidia.com> <1372928979-26938-2-git-send-email-wni@nvidia.com> <51D70483.70203@wwwdotorg.org>	<51DA6BD4.1040300@nvidia.com> <20130708095024.041a6d57@endymion.delvare>	<51DA8805.50709@nvidia.com> <20130708131421.GB21638@roeck-us.net>	<20130709062112.GC17499@mithrandir> <51DBC058.2040904@nvidia.com> <20130709095525.5158a0a5@endymion.delvare>
In-Reply-To: <20130709095525.5158a0a5@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:55 PM, Jean Delvare wrote:
> On Tue, 9 Jul 2013 15:48:40 +0800, Wei Ni wrote:
>> On 07/09/2013 02:21 PM, Thierry Reding wrote:
>>> It should work out of the box. As a matter of fact the same chip is used
>>> on Tamonten and the DTS files use "onnn,nct1008". That used to work. If
>>> it no longer does then that's a regression.
>>
>> I synced the linux-next from:
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> and use the tag v3.10-rc7, but in the lm90.c it doesn't have DT support,
>> such as "onnn,nct1008".
>> I googled it and found there has patch:
>> [PATCH] hwmon: (lm90) Add device tree support , which is in:
>> http://lists.lm-sensors.org/pipermail/lm-sensors/2013-February/038099.html
>> , but it didn't be merged into the linux-next.
> 
> It was not, because of the next reply in the same thread:
> http://lists.lm-sensors.org/pipermail/lm-sensors/2013-February/038100.html
> 
>> which git repository and branch should I use ?
> 
> It is supposed to just work. What doesn't work for you exactly?
> 

Oh, yes, the "onnn,nct1008" can work. I read the i2c driver and the
of_i2c.c carefully, I understand why the lm90 can be loaded by setting
"onnn,nct1008". Indeed, we can set the vendor string to anything, even
"xxx,nct1008", the lm90 also can be loaded correctly.

Anyway, I will use the "onnn,nct1008" in my next version.

Thanks for your comments.
Wei.




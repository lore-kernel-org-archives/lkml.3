Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab3CWKF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 06:05:26 -0400
Received: from smtp-out-087.synserver.de ([212.40.185.87]:1074 "EHLO
	smtp-out-087.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3CWKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 06:05:25 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25369
Message-ID: <514D7ED4.2030205@metafoo.de>
Date: Sat, 23 Mar 2013 11:07:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com> <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com> <514B4CBF.7070106@metafoo.de> <514B7C80.2070008@gmail.com>
In-Reply-To: <514B7C80.2070008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 10:32 PM, Sebastian Hesselbarth wrote:
>>> +
>>> +    dev_info(&client->dev, "registered si5351 i2c client\n");
>>> +
>>
>> That's just noise, imagine every driver would print such a line, your bootlog
>> would be scrolling for hours ;) I'd either remove it or make it dev_dbg
> 
> Actually, I understand not to have it, but if you don't want it you can still
> boot with "quiet", can't you? Having one single line that helps you see it has
> been probed helps a lot. But, I don't have a strong opinion on that and can
> make it dev_dbg.

It is useful during development, but in my opinion only as long as not every
other driver does this as well. If you want to check whether a device has
been probed you can easily do this by checking the drivers sysfs node.

- Lars

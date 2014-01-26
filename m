Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaAZWCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 17:02:49 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62818 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaAZWCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 17:02:15 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E585E8.4000100@roeck-us.net>
Date: Sun, 26 Jan 2014 14:02:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, LM Sensors <lm-sensors@lm-sensors.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
References: <52E561D0.4040308@roeck-us.net> <20140126211357.6fa68909@endymion.delvare> <52E573B6.9040903@roeck-us.net> <20140126214936.7736f530@endymion.delvare> <20140126212256.GK11727@sirena.org.uk> <52E580CE.8080100@roeck-us.net> <20140126215354.GL11727@sirena.org.uk>
In-Reply-To: <20140126215354.GL11727@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 01:53 PM, Mark Brown wrote:
> On Sun, Jan 26, 2014 at 01:40:30PM -0800, Guenter Roeck wrote:
>> On 01/26/2014 01:22 PM, Mark Brown wrote:
>
>>> What is this platform and why does it have the regulator API enabled in
>>> the first place?
>
>> It is a PC running Ubuntu. you'd have to ask the distro maintainers why they
>> turn on regulators.
>
>> config-3.8.0-26-generic:CONFIG_REGULATOR=y
>> config-3.8.0-35-generic:CONFIG_REGULATOR=y
>> config-3.11.0-13-generic:CONFIG_REGULATOR=y
>
> Oh, magic.  Can you please file a bug with or otherwise talk to them
> asking them to turn that off (or contribute code to make it work)?  Feel
> free to add me as a CC when you do so.
>

That means they would have to stop supporting anything that _does_ need regulators,
which doesn't make much sense to me.

I think the bug is on your side, not theirs.

Guenter


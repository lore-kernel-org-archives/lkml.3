Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3IRUpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:45:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60942 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3IRUpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:45:46 -0400
Message-ID: <523A10F5.7090009@wwwdotorg.org>
Date: Wed, 18 Sep 2013 14:45:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-rpi-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/26] ARM: provide common arch init for DT clocks
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130918194711.GR19937@titan.lakedaemon.net> <523A046E.6040804@gmail.com>
In-Reply-To: <523A046E.6040804@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 01:52 PM, Sebastian Hesselbarth wrote:
> On 09/18/2013 09:47 PM, Jason Cooper wrote:
>> On Wed, Sep 18, 2013 at 07:53:33PM +0200, Sebastian Hesselbarth wrote:
>> ...
>>> Sebastian Hesselbarth (26):
>>>    ARM: nomadik: move mtu setup to clocksource init
...
>>
>> How would you like to handle this series?
> 
> Jason,
> 
> honestly I don't really know, yet. I was hoping for Arnd and Olof
> decide on that. Maybe they also create a topic branch up to where
> arch-wide of_clk_init is introduced. Then each removal patch can
> go through the independent sub-trees. There may be more machs
> introduced before, that can then also depend on the common branch.

Oh, I was assuming you'd just take the whole thing through one tree,
likely in arm-soc. That's why I created the topic branch for the Tegra
PMIC patch that's a dependency of this... However, I guess if you just
merge the core into a topic branch in arm-soc and everyone merges it
back, that's fine. I assume the Tegra topic branch I created won't be
necessary in that case.

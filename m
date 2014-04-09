Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbaDIPci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:32:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47651 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaDIPcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:32:36 -0400
Message-ID: <5345680F.3040903@wwwdotorg.org>
Date: Wed, 09 Apr 2014 09:32:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCHv3 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com> <1396946275.5936.2.camel@jlt4.sipsolutions.net> <20140409100147.GB3083@xps8300>
In-Reply-To: <20140409100147.GB3083@xps8300>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 04:01 AM, Heikki Krogerus wrote:
> Hi,
> 
> On Tue, Apr 08, 2014 at 10:37:55AM +0200, Johannes Berg wrote:
>> On Tue, 2014-04-01 at 17:02 +0300, Heikki Krogerus wrote:
>>> I hope this one is OK with everyone.
>>
>> It's fine with me. Are you expecting me to pick up any of these patches,
>> or do you want them to go through some other tree? Either way is fine
>> with me, but the first patch looks like something I probably shouldn't
>> be taking.
> 
> The second patch depends on it.
> 
> Stephen! Are you expecting any changes to board-paz00.c in this kernel
> cycle? If not, I think it would be easiest if Johannes, you take the
> whole set. What do you guys think?

I can't predict the future, but the chances are pretty slim - that file
is pretty tiny and doesn't have much churn.

The best approach is to put this series in its own topic branch. Then,
if any conflict does come up, I can simply merge the branch into the
Tegra treee and apply the conflicting patches on top.

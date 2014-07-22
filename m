Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaGVAq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:46:28 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52356 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaGVAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:46:26 -0400
Message-ID: <53CDB45C.10805@collabora.co.uk>
Date: Tue, 22 Jul 2014 02:46:20 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/13] Add Maxim 77802 PMIC support
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk> <53CD0B17.5040706@collabora.co.uk> <20140722001053.GO17528@sirena.org.uk>
In-Reply-To: <20140722001053.GO17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 02:10 AM, Mark Brown wrote:
> On Mon, Jul 21, 2014 at 02:44:07PM +0200, Javier Martinez Canillas wrote:
>> On 07/14/2014 01:35 PM, Javier Martinez Canillas wrote:
> 
>> Mark, Mike and Alessandro,
> 
>> This is a gentle reminder to look at the patches that touches your subsystems
>> and provide acks if possible so Lee can merge the remainder set through the mfd
>> tree.
> 
> Please stop nagging, you are chasing after only one week which is
> excessive for something that isn't an urgent bugfix (especially
> with a series like this that has had many rapid repins).  Several weeks
> to a month would be more appropriate, and then resending the patches
> rather than sending contentless pings is more useful.  Sending mails
> like this just means that people have more mail to read that isn't your
> patch, it is more likely to get you negative attention than positive -
> for example, I will tend to deprioritise things where I'm being chased
> too urgently as I do not wish to encourage such behaviour by being seen
> to reward it.
> 

I didn't mean to bother you. It's true that it has been only a week since I
posted v8 of this series but I didn't have feedback for the clock, rtc and
regulator drivers since v5 which was posted on June, 26 so I thought that a ping
just to be sure it was not forgotten was not that bad. But sorry I won't do it
again and will just wait.

About the many re-spins, as most mfd drivers this PMIC support touches different
subsystems and the series had many patches so each time I had feedback for some
patches I prepared a new version and reposted the whole series. This doesn't
mean that all the patches changed from version to version though, some patches
have not changed for several revisions.

> In general I would recommend taking a step back, slowing down, and if
> you are not getting a response either thinking of something else to do
> in parallel or trying to do things that make it easier to accept your
> change if there are any (sometimes it's just a case of waiting).  Look
> at how frequently the relevant maintainers tend to respond, at what the
> previous review comments have been and also consider the possibility
> that people might take holidays or just be busy.
> 

Sorry, I didn't mean to imply that you are not busy or might be on holidays. I
guess I just got anxious due the merge window being close...

Best regards,
Javier

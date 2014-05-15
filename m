Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaEOIZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:25:08 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:55081 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaEOIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:25:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2014 10:24:39 +0200
From: Stefan Agner <stefan@agner.ch>
To: Thierry Reding <thierry.reding@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: swarren@wwwdotorg.org, linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
In-Reply-To: <20140515075102.GE5952@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
 <20140515075102.GE5952@ulmo>
Message-ID: <4de1d09b7873e012e43525c1f8ab9c66@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry, hi Philipp,

Am 2014-05-15 09:51, schrieb Thierry Reding:
> On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
>> From: Stefan Agner <stefan@agner.ch>
>>
>> This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
>> evaluation kits.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> Panel patches should go to the dri-devel mailing list as well.
> 
> Also a patch was posted only yesterday for a panel that seems to be the
> exact same one as this, even though the name differs minimally, see:
> 
> 	https://patchwork.kernel.org/patch/4175251/
> 
> Adding Philipp on Cc so you guys can work together whether this is
> indeed the same panel. The only differences seem to be in the vertical
> front and back porches, but I suspect that either settings will work on
> both Tegra and i.MX.

Its etm0700g0dh6 vs. et070080dh6, Philipp's panel is with captive multi
touch, (hence the M I guess). The panel itself really looks the same.

I found this overview of EDT displays:
http://www.dmbtechnics.com/scripts/passthru.php?id=7

There seem to be quite a lot variants with the same panel...

Regarding timings, I just checked the documentation, Philipp's timing
really matches the documented ones, I miscalculated the vertical back
porch.

How do we resolve that?

I would suggest that I split out that patch and remove the et070080dh6
panel and send the other as a single patch to the dri-devel mailing list
as well.

Philipp, could you add my display type (et070080dh6) to the compatible
list of your mode/panel entry?

Does this sound reasonable?

--
Stefan

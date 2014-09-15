Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaIOODR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:03:17 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38883 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaIOODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:03:13 -0400
Message-ID: <5416F19D.4030105@collabora.co.uk>
Date: Mon, 15 Sep 2014 16:03:09 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v9 1/5] rtc: max77686: Allow the max77686 rtc to
 wakeup the system
References: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>	<1410509864-10019-2-git-send-email-javier.martinez@collabora.co.uk> <20140912150537.56419981804c68f9108a22b6@linux-foundation.org>
In-Reply-To: <20140912150537.56419981804c68f9108a22b6@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Thanks a lot for taking a look to these patches!

On 09/13/2014 12:05 AM, Andrew Morton wrote:
> On Fri, 12 Sep 2014 10:17:39 +0200 Javier Martinez Canillas <javier.martinez@collabora.co.uk> wrote:
> 
>> From: Doug Anderson <dianders@chromium.org>
>> 
>> The max77686 includes an RTC that keeps power during suspend.  It's
>> convenient to be able to use it as a wakeup source.
>> 
>> NOTE: due to wakeup ordering problems this patch alone doesn't work so
>> well on exynos5250-snow.  You also need something that brings the i2c
>> bus up before the max77686 wakeup runs.
> 
> I removed this paragraph.
> 

Great.

>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> And I rewrote this to Signed-off-by:, as you were on the patch delivery
> path. Documentation/SubmittingPatches section 12 has the gory details.
> 

Yes, originally Doug posted this patch separately but was never picked so I
included on my series but forgot to add my s-o-b and also to remove the note
paragraph.

Best regards,
Javier


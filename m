Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaJTVrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:47:47 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40409 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJTVrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:47:45 -0400
Message-ID: <544582FC.9010005@collabora.co.uk>
Date: Mon, 20 Oct 2014 23:47:40 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>	<1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=XnBWWKbrey1zmxtAzGYviJJad4pWOC4=bbf2e2OBgaeQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XnBWWKbrey1zmxtAzGYviJJad4pWOC4=bbf2e2OBgaeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 10/20/2014 11:40 PM, Doug Anderson wrote:
> Javier,
> 
> On Mon, Oct 20, 2014 at 2:05 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> The regulator framework has a set of helpers functions to be used when
>> the system is entering and leaving from suspend but these are not called
>> on Exynos platforms. This means that the .set_suspend_* function handlers
>> defined by regulator drivers are not called when the system is suspended.
>>
>> Suggested-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 
> I think you forgot to carry Chanwoo's review:
> 
> Reviewed-by: Chanwoo Choi<cw00.choi@samsung.com>
> 
> I don't think you've made any changes that would need to invalidate his review.
> 

Yes, I forgot to add the tag to my local branch so it was missed when generating
the patch for the new version, sorry about that...

Best regards,
Javier

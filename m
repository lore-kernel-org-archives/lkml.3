Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab3GLPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:37:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34121 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964936Ab3GLPhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:37:31 -0400
Message-ID: <51E0227E.2000008@ti.com>
Date: Fri, 12 Jul 2013 18:36:30 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com> <20130625065811.GZ5523@atomide.com> <51CAEA90.90200@ti.com> <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com> <51CC45D3.2000305@ti.com> <CACRpkdYU13bhPaL2ZG9CT9JRv9sKQ+1N3zCUPizk571+LQqB4A@mail.gmail.com>
In-Reply-To: <CACRpkdYU13bhPaL2ZG9CT9JRv9sKQ+1N3zCUPizk571+LQqB4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 07/10/2013 11:36 PM, Linus Walleij wrote:
> On Thu, Jun 27, 2013 at 4:01 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>
>> I think, In the future the OMAP pinctrl configurations would be manged in
>> more flexible way then now (thanks to "pinctrl PM helpers" and you;))
>> - "Idle" state will be splitted to "Idle"/"sleep"
>> - "default" state will be splitted to "default"/"active"
>
> OK so the first ones we already have so the discussion is now down
> to adding the "active" state (and pinctrl_pm* helper function).
>
> I guess we need a patch set prepared which adds the "active" state
> and helper function as the first patch, i.e. this:
> http://marc.info/?l=linux-kernel&m=137094012703340&w=2
> Can I have your ACK on this patch?
I've verified combination of
[PATCH] drivers: pinctrl: add active state to core
[RFC] ARM: OMAP2+: omap_device: add pinctrl handling
on OMAP4 SDP board+UARTs and going to send patches on Monday.

So, Acked/Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
(I can't reply directly to thread - not signed to those lists :))

What is the best branch to base my patches on?

>
> I do not want to add the state unless there is a clear consumer,
> so it needs to go in with the first patch to a device driver that uses
> pinctrl_pm_select_active_state() which will be a good demonstration
> on its use and utility. (And a point to object and suggest other ways
> to do the same thing...)
>
> Yours,
> Linus Walleij
>

Regards,
-grygorii

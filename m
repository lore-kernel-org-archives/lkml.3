Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaGHPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:23:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45188 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaGHPXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:23:13 -0400
Message-ID: <53BC0CBE.4060608@ti.com>
Date: Tue, 8 Jul 2014 10:22:38 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered
 hwspinlock banks
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-4-git-send-email-s-anna@ti.com> <CAK=WgbakGbTaYz+4K24aT3vyRkDYwPKCm6XrcJvH667NMMfTTA@mail.gmail.com> <53B47621.6090307@ti.com> <CAK=WgbYtJ7TGqvjG3VAPPD5tVXx9-jEJU3iKEStUMxOvD1v=LQ@mail.gmail.com> <53B592CE.2010001@ti.com> <CAK=WgbaahqdmWRDMKtRhco4y5B-WBFYDHYs2cLM7NL=QhnhK2Q@mail.gmail.com>
In-Reply-To: <CAK=WgbaahqdmWRDMKtRhco4y5B-WBFYDHYs2cLM7NL=QhnhK2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/04/2014 12:01 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, Jul 3, 2014 at 8:28 PM, Suman Anna <s-anna@ti.com> wrote:
>> OK, but we would still require this function to lookup the registered
>> device from the controller-phandle to retrieve the base_id.
> 
> Can we retrieve the base_id from the parent DT node itself?

Yeah, it is possible using the of_hwspin_lock_get_base_id function added
in Patch8, once we convert the phandle to a device node. The platform
implementations would be using this function during the registration
phase to register the base id, and we have to do the DT parse/lookup
again in the core.

regards
Suman

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3FDJIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:08:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44497 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3FDJIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:08:39 -0400
Message-ID: <51ADAE78.4050900@ti.com>
Date: Tue, 4 Jun 2013 14:38:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <1369911393-25747-1-git-send-email-kishon@ti.com> <20130530113247.GI5180@sirena.org.uk> <51A74D70.5060303@nvidia.com> <20130601184511.GC16790@sirena.org.uk> <51AA456E.3030307@nvidia.com> <20130601210511.GT16790@sirena.org.uk>
In-Reply-To: <20130601210511.GT16790@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 02 June 2013 02:35 AM, Mark Brown wrote:
> On Sun, Jun 02, 2013 at 12:33:10AM +0530, Laxman Dewangan wrote:
>> On Sunday 02 June 2013 12:15 AM, Mark Brown wrote:
>
>>> No, that makes no sense at all to me.  Why do you think this maps onto
>>> the set mode API?  Modes are all about accuracy of regulation.
>
>> I mapped this to the regulation under different load, Fast mode is
>> in heavy load and so boost enable, normal/idle mode for normal load
>> and so bypass.
>
> This is still not making any sense.  The quality of regulation and
> output voltage are essentially orthogonal, and obviously there's a
> specific API for bypass which is something different again to both
> mode and output voltage selection.

Do you recommend adding API's (similar to bypass) for BOOST and SWITCH?

Thanks
Kishon

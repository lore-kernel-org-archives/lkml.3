Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3FXOxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:53:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3FXOxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:53:34 -0400
Message-ID: <51C85D46.3040209@ti.com>
Date: Mon, 24 Jun 2013 20:22:54 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 3/3] ARM: davinci: da850: adopt to pinctrl-single driver
 to configure multiple pins
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com> <1369145282-14419-5-git-send-email-prakash.pm@ti.com> <A73F36158E33644199EB82C5EC81C7BC3EA911E0@DBDE04.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3EA911E0@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2013 5:18 PM, Manjunathappa, Prakash wrote:
> Hi Sekhar,
> 
> On Tue, May 21, 2013 at 19:38:02, Manjunathappa, Prakash wrote:
>> function-mask property is a mask for a pin at each pin configure offset
>> in a pincontrol register.
>>
> 
> Got 1/3 and 2/3 accepted, I do not know if this gets merged via DaVinci tree or
> pincontrol tree. Could you please takecare of this?

I will send this via DaVinci tree. I had actually missed that there is a
bit waiting for me here. So thanks for asking.

Regards,
Sekhar

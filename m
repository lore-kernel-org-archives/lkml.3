Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615Ab3DHNKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:10:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46922 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935389Ab3DHNK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:10:26 -0400
Message-ID: <5162C1A5.5060808@ti.com>
Date: Mon, 8 Apr 2013 18:39:57 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: Re: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com> <1364197789-16783-4-git-send-email-avinashphilip@ti.com> <515A97DE.1080403@ti.com> <518397C60809E147AF5323E0420B992E3EAA91B6@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EAA91B6@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 4/8/2013 2:39 PM, Philip, Avinash wrote:
> On Tue, Apr 02, 2013 at 14:03:34, Nori, Sekhar wrote:
>> On 3/25/2013 1:19 PM, Philip Avinash wrote:
>>> Add da850 EHRPWM & ECAP DT node.
>>> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
>>> clock.
>>
>> This looks fine to me but I will wait for the bindings to get accepted
>> before taking this one.
> 
> Sekhar,
> 
> Binding document got accepted in PWM tree [1].
> Can you accept this patch?

Can you also add the pinmux definitions and resend just this patch?
Sorry I did not notice those were missing earlier.

Thanks,
Sekhar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3FCJyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:54:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47062 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3FCJyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:54:11 -0400
Message-ID: <51AC6797.1040304@ti.com>
Date: Mon, 3 Jun 2013 11:53:27 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Mohammed, Afzal" <afzal@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Jon Hunter <jgchunter@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/14] Documentation: dt: binding: omap: am43x timer
References: <cover.1369658705.git.afzal@ti.com> <223d90dc9eeab13d8496690d336cdf0f7d27cd22.1369658705.git.afzal@ti.com> <51A520B5.8040803@gmail.com> <51A52A16.1040204@wwwdotorg.org> <C8443D0743D26F4388EA172BF4E2A7A93EAFB044@DBDE04.ent.ti.com> <51A5BEB6.6070809@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EAFB174@DBDE04.ent.ti.com> <51A60427.6010409@ti.com> <C8443D0743D26F4388EA172BF4E2A7A93EB1238B@DBDE04.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EB1238B@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

On 06/03/2013 09:49 AM, Mohammed, Afzal wrote:
> Hi Benoit,
> 
> On Wed, May 29, 2013 at 19:05:35, Cousson, Benoit wrote:
> 
>> And in this case, you do not introduce any new revision.
>>
>> There is no point to update the binding each time we add a new SoC
>> variant that will contain the exact same IP.
>>
>> I think it will mainly confuse the user that will wonder what is
>> different in that version compare to the previous one, moreover we can
>> end up with hundred of entries for the exact same IP for nothing.
>>
>> The real problem is due to the introduction of the SoC name in the
>> device compatible name. That does introduced a SoC level information
>> that is mostly irrelevant at device level. I can understand why it was
>> done for practical aspect when the IP version is not well identified,
>> but that can lead to this proliferation of new pointless bindings.
> 
> As opinions on $subject seems not yet to be conclusive, I plan to
> rebase DTS patch (14/14) over your 'for_3.11/dts' branch (that makes
> use of C preprocessor on OMAP DTS) and post separately dropping
> 11-14 patches, is that okay ?

Yes, that sounds good to me.

Thanks,
Benoit


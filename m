Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3GRRSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:18:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33276 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3GRRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:18:10 -0400
Message-ID: <51E8234D.1020607@wwwdotorg.org>
Date: Thu, 18 Jul 2013 11:18:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: Guenter Roeck <linux@roeck-us.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <20130717220942.GB990@roeck-us.net> <51E7F341.8020508@ti.com>
In-Reply-To: <51E7F341.8020508@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 07:53 AM, Eduardo Valentin wrote:
> Hello Guenter,
> 
> On 17-07-2013 18:09, Guenter Roeck wrote:
>> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin
>> wrote:
>>> Hello all,
>>> 
>>> As you noticed, I am working in a way to represent thermal
>>> data using device tree [1]. Essentially, this should be a way
>>> to say what to do with a sensor and how to associate (cooling)
>>> actions with it.
>>> 
>> Seems to me that goes way beyond the supposed scope of devicetree
>> data. Devicetree data is supposed to describe hardware, not its
>> configuration or use. This is clearly a use case.
> 
> Thanks for rising your voice here. It is important to know what
> hwmon ppl think about this.

I meant to find time to read Guenter's original email where he
initially objected to putting data into DT, and determine exactly what
was being objected to. I still haven't:-( However, the arguments that
Eduardo stated in his email do make sense to me; I agree that
temperature limits really are a description of HW. Details of which
cooling methods to invoke when certain temperature limits are reached
is also part of the HW/system design, and hence I would tend to agree
that they're appropriate to include in DT. Anyway, that's just my 2
cents on the matter:-)

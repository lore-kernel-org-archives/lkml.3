Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3CII0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:26:55 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37148 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3CII0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:26:54 -0500
Message-ID: <513AF24A.2070200@gmail.com>
Date: Sat, 09 Mar 2013 09:26:50 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Afzal Mohammed <afzal.mohd.ma@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: Question about fixed-clock
References: <20130307184240.GA3327@afzal-ThinkPad-R50e> <5139155F.5050407@gmail.com> <20130308021527.GA28481@opensource.wolfsonmicro.com> <5139E7F3.5010906@gmail.com>
In-Reply-To: <5139E7F3.5010906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 02:30 PM, Daniel Mack wrote:
> On 08.03.2013 03:15, Mark Brown wrote:
>> On Thu, Mar 07, 2013 at 11:31:59PM +0100, Daniel Mack wrote:
>>> On 07.03.2013 19:42, Afzal Mohammed wrote:
>>> Grep'ing through arch/arm, it seems that the imx arch does the same
>>> thing my patch does, but I could also imagine that it should be done
>>> somewhere from the DT core. I copied Grant, Rob and Mark for more comments.
>>
>> Wouldn't this just be set up by the DT in the same way that other
>> off-SoC hardware is?
 >
 > [...]
>
> I don't know the clock framework well enough, but it seems that either
> all DT boards are supposed to do the same in their generic bits (which
> sounds like a lot of code duplication), or the fixed-clock driver should
> behave like any other driver wrt its probing from DT. I'm open to
> suggestions :)

Daniel,

the current common clock framework does not register any of its "core"
clocks, i.e. fixed-clock, et.al. I haven't had a look at the way regulator
api registers them. But if you find the way reasonable, why not propose
a patch for ccf that registers at least a set of the core clocks itself?

Sebastian


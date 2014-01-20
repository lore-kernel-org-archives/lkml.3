Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaATQUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:20:52 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53223 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATQUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:20:49 -0500
Message-ID: <52DD4CDE.7020705@gmail.com>
Date: Mon, 20 Jan 2014 17:20:46 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Ianovich <ynvich@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>	 <201312182210.30544.arnd@arndb.de>	 <1387401646.31516.14.camel@host5.omatika.ru>	 <201312190630.11087.arnd@arndb.de>	 <1389309176.32346.1.camel@host5.omatika.ru> <1390234117.25903.0.camel@host5.omatika.ru>
In-Reply-To: <1390234117.25903.0.camel@host5.omatika.ru>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 05:08 PM, Sergei Ianovich wrote:
> On Fri, 2014-01-10 at 03:12 +0400, Sergei Ianovich wrote:
>> On Thu, 2013-12-19 at 06:30 +0100, Arnd Bergmann wrote:
>>> This would work only if we can probe the devices behind the external
>>> bus controller before the controller itsef has been set up, since
>>> the initialization order can depend on a number of things but not
>>> the bus hierarchy. It will also work if the code setting up the
>>> bus controller can be guaranteed to run before we call
>>> of_platform_populate for the regular devices, which is probably
>>> the best solution here.
>>
>> There has been no activity for 3 weeks. Could we resume the series?
> 
> It's over a month now. Is anything wrong?
> 

No, I'm busy, that's all.

That said, the current situation is

a) we need someone to have a look at the performance regression of the
MMC file system layer that you reported. I couldn't find a PXA-based
board yet with a MMC slot soldered on it. But as you apparently have
such hardware, I'd really appreciate your help here. Could you do some
measurements and see whether you see major differences in packet size or
timings?

b) Marek Vasut thankfully reported back to me and signaled success with
his pxa-pata driver. So we're most probably good in that area.

c) Robert Jarzmik is still in the process of converting the camera
driver. Here as well, I lack hardware, I can't even compile-test
anything here.


So please, if you have any spare time, have a look at the MMC
regressions and see if you can contribute anything. I'll hope to find
some time to rebase my patches on top of 3.13 very soon, so we have a
new base to work on.


Thanks,
Daniel


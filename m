Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3C0D0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:26:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54891 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3C0D0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:26:54 -0400
Message-ID: <515266FC.5090103@wwwdotorg.org>
Date: Tue, 26 Mar 2013 21:26:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lubomir Rintel <lkundrak@v3.sk>
CC: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add Broadcom BCM2708 watchdog timer driver
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>  <514D1273.8070902@wwwdotorg.org> <1364134324.2906.8.camel@hobbes.kokotovo>
In-Reply-To: <1364134324.2906.8.camel@hobbes.kokotovo>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 08:12 AM, Lubomir Rintel wrote:
> On Fri, 2013-03-22 at 20:24 -0600, Stephen Warren wrote:
> 
> Thank you for your response!
> 
>> On 03/22/2013 06:55 AM, Lubomir Rintel wrote:
>>> Signed-off-by: Lubomir Rintel <lkundrak at v3.sk>

>> I'm curious where you got the documentation to write this driver; this
>> HW module isn't described in BCM2835-ARM-Peripherals.pdf. I assume this
>> is based on the downstream kernel driver? If so, at least some credit in
>> the commit description might be appropriate. At least the relevant
>> commit downstream already has an appropriate Signed-off-by line:-)
> 
> Your guess is right, used bcm2708_wdog driver from rpi-3.6.y as a reference. 
> I'll add that information to the commit message.
> 
> The Signed-off-by line is indeed present, but unfortunately does not seem to be 
> particularly appropriate:
> 
> Signed-off-by: popcornmix <popcornmix@gmail.com>

That s-o-b line maps to Dom Cobley. In a previous message on the
linux-rpi-kernel mailing list, he gave his permission to re-write the
name part of that to "Dom Cobley". That would make the s-o-b useful.

http://lists.infradead.org/pipermail/linux-rpi-kernel/2012-September/000154.html


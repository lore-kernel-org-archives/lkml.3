Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3IZJoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:44:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3IZJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:44:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [PATCH v6 RESEND 0/5] ARM/ARM64 architected timer updates
Date: Thu, 26 Sep 2013 11:43:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>
References: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <5242FC09.2050604@linaro.org> <52431B37.5000901@arm.com>
In-Reply-To: <52431B37.5000901@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201309261143.55010.arnd@arndb.de>
X-Provags-ID: V02:K0:xpYIWBBV0C20sahzy/hjuwGOBJKWksxaJiOrR/fATtc
 amTjeBA5juYFyejkax1TgnpGwWl26flIYjz6clEWWxr0luptjH
 U4uDIVhk34y8ySfAjjweo2WJ46n8MGDkTH0vMXG3OE6G/dx3G9
 yamgwgE+M6wLdaZ8OFHLHdq7MCFShVWYKx4n6DHKeU83fAuBAa
 Zh7cCjyS3c91FgcLbmnrVyTTJuzgyC2XEAujE9wCtd55ZPhdP4
 g4qCQ13F/1lFD7HEs88ANUk2t3rWFJdQEnlRgq73lcaNf8yE3J
 dO8+UBsFOB+oXVwHT2ztBk76juOFkxoPWbCKepvw8mXrvkfCwF
 K9ZLuoXi4CwMfOtSQErQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 September 2013, Sudeep KarkadaNagesha wrote:
> On 25/09/13 16:06, Daniel Lezcano wrote:
> > On 09/18/2013 01:05 PM, Sudeep KarkadaNagesha wrote:
> >> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> >>
> >> Hi Olof/Kevin,
> > 
> > Added Olof and Kevin in Cc.
> > 
> Thanks Daniel, sorry I assumed mailing list alias(arm@kernel.org) was preferred way.
> 

The alias is mainly for when you are sending a pull request or a patch to
be applied directly. For any review it makes more sense to Cc the ones you
want involved directly.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3FYNct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:32:49 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38251 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3FYNcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <51C99AB5.1080002@imgtec.com>
References: <201306251455.01540.heiko@sntech.de>
	<201306251456.36499.heiko@sntech.de>
	<51C99581.2010403@imgtec.com>
	<201306251521.55634.heiko@sntech.de>
	<51C99AB5.1080002@imgtec.com>
Date: Tue, 25 Jun 2013 15:32:47 +0200
Message-ID: <CACRpkdbdwvmBYFX=ppdM_RmGwyTcWVeTCMj60F4sh6YEVRE2Uw@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 3:27 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 25/06/13 14:21, Heiko Stübner wrote:

>> My thoughts were that this code would never be reached when the parsing was
>> removed and to not cause confusion to the driver when an acceptable binding
>> was found for slew-rate.
>>
>> But it of course also doesn't hurt to stay in.
>
> Okay, fair enough.
>
> Acked-by: James Hogan <james.hogan@imgtec.com>

OK applied this so we have a clean slate.

Patches adding it back in with SI measures will be welcomed!

Yours,
Linus Walleij

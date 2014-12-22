Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaLVCTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:19:49 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:48198 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaLVCTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:19:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141222015729.GE28117@titan.lakedaemon.net>
References: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
	<20141222015729.GE28117@titan.lakedaemon.net>
Date: Sun, 21 Dec 2014 19:19:47 -0700
Message-ID: <CANLsYkws1CBAypzQjicphr7j0nGnf019pN2iR2wvyqmkdRuWQg@mail.gmail.com>
Subject: Re: [PATCH] staging: skein: Fixing various coding style problems
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 December 2014 at 18:57, Jason Cooper <jason@lakedaemon.net> wrote:
> Mathieu,
>
> On Sun, Dec 21, 2014 at 05:09:48PM -0700, mathieu.poirier@linaro.org wrote:
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> Fixing errors related to the usage of do {} while (0) loop
>> in single statement macros, trailing semicolon in macros and
>> trailing whitespace.
>
> Huh.  iirc, I added those do {} while(0)s to keep checkpatch happy.
> Either it's gotten smarter, or something is off.

Checkpatch apparently changed it's mind.

>
> At any rate, the whole macro menagerie in here concerns me a bit and I'm
> reluctant to change it until I have some time to refresh my memory on
> what this code is doing.
>
> It would be helpful if you could give scripts/objdiff a try on the
> before and after effects of your patch.  If the object code doesn't
> change, then we can be more confident that the patch is just style
> changes.  Please also check when SKEIN_UNROLL_* is set/unset.

You got it.

>
> I really should put the patch series together to move this driver out of
> staging.  Then maybe folks will stop running checkpatch against it :-)
>
> thx,
>
> Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaEADcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:32:12 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54160 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaEADcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E261E9@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
	<1398760700-19397-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E24280@P3PWEX4MB008.ex4.secureserver.net>
	<CA+jnaaV7YDQYAGg_yksfiD31bCGN0brvZvBqi0VrK6hV_moxzA@mail.gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E261E9@P3PWEX4MB008.ex4.secureserver.net>
Date: Wed, 30 Apr 2014 22:32:07 -0500
Message-ID: <CA+jnaaW0=4BDpEcZzBZSF7f9qY3JhQF61qZERR0pjWQMX0BOXQ@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] staging: comedi: addi_apci_1564: remove use of devpriv->s_EeParameters
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartley,

Yes, you raise very good points.  In any case, I have added cover
letters to my submitting checklist so hopefully everything will be a
lot easier for everyone next go round.

Thanks,
Chase

On Wed, Apr 30, 2014 at 11:58 AM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On Wednesday, April 30, 2014 12:52 AM, Chase Southwood wrote:
>> Thanks so much, I greatly appreciate the review.  I'll fix the
>> changelog for patch 4 and send once more (as I assume that's easier
>> for Greg).  Also, I should know better about the cover letter as
>> well...I was once told not to send them for strictly cleanup patchsets
>> (as Greg can't do anything with them and cleanups should be obvious)
>> but I've gotten in the habit of not doing a cover letter for any
>> patchsets.  I will send cover letters (and be more careful about my
>> other mistakes) in the future.
>
> Chase,
>
> Good job on the cleanup you have done so far.
>
> The cover letter does not get committed as part of the patch set. But
> when you are submitting a series it give a convenient  place to add
> the sign off tag for a series. Also, if you would have done a cover letter
> for this series you would have probably spotted the subject line issues
> in patches 5 and 6.
>
> Keep up the good work!
>
> Hartley
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab3IDXEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:04:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60321 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab3IDXE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:04:28 -0400
Message-ID: <5227BC71.6000907@zytor.com>
Date: Wed, 04 Sep 2013 16:04:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Andy Lutomirski <luto@amacapital.net>, Arun Sharma <asharma@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
Subject: Re: clock_gettime_ns
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com> <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com> <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com> <52279E1D.3060907@linaro.org> <5227B432.8070205@zytor.com> <5227BB50.7000301@linaro.org>
In-Reply-To: <5227BB50.7000301@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:59 PM, John Stultz wrote:
> 
> Also, there's been talk of a slewed-leap-second clockid, basically UTC
> but around the leapsecond it slows down to absorb the extra second. This
> means that clockid would have a subsecond offset from TAI.
> 

Most of what I have heard seem to center around abolishing leap seconds
entirely.  Now, I know that some users do slewed leap seconds as a
unofficial policy to avoid rare events.

	-hpa



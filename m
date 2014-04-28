Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaD1QhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:37:02 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:47861 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaD1Qgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140428115745.GZ21279@lee--X1>
References: <1398180298-2018-4-git-send-email-dianders@chromium.org>
	<20140422190754.GF12304@sirena.org.uk>
	<20140423105540.GJ21613@lee--X1>
	<CAD=FV=V0uWMGTt68CST5i30Xf4pTNMt50-D7XeRmtSdfbPwwLQ@mail.gmail.com>
	<20140428115745.GZ21279@lee--X1>
Date: Mon, 28 Apr 2014 09:36:52 -0700
X-Google-Sender-Auth: PHXNSYwT-RY3ho9y94ig9ZG1tWU
Message-ID: <CAD=FV=X8++r4PYvy-p+YC37n9zkbCSoDZFSC7=WHe4mSF1X7PQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v3 3/5] mfd: tps65090: Stop caching most registers
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Mon, Apr 28, 2014 at 4:57 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >> > Nearly all of the registers in tps65090 combine control bits and
>> >> > status bits.  Turn off caching of all registers except the select few
>> >> > that can be cached.
>> >>
>> >> Lee, I don't mind if I apply this and send a pull request to you or I
>> >> pull a tag from you with this in - what's easiest for you?
>> >
>> > I'm happy to do it.
>> >
>> > Doug,
>> >   Can you send the patch-set again with all of the *-bys and ensure
>> >   I'm on TO or CC please?
>>
>> It looks as if you've already applied 1, 3, and 4.  I've sent up 2 and
>> 5 again with collected tags.
>>
>> https://patchwork.kernel.org/patch/4042761/
>> https://patchwork.kernel.org/patch/4042751/
>
> I think we have this sorted now. I sent a pull-request to Mark this
> morning.

Thanks!  I'll keep an eye on linux-next to make sure everything is
there.  It sounds like the charger patch
<https://patchwork.kernel.org/patch/4042751/> wasn't picked up by
anyone.  I'll see if I can find someone to take that.  Luckily that
can be applied independently of everything else (it just won't fix
everything till all the patches are together).

-Doug

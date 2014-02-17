Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaBQGM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:12:26 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:35588 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaBQGMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:12:25 -0500
MIME-Version: 1.0
In-Reply-To: <5301A64F.2090205@yahoo.com.au>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<5301A64F.2090205@yahoo.com.au>
Date: Mon, 17 Feb 2014 11:42:24 +0530
Message-ID: <CABb+yY3mPpL_Ku=WheOGoJt_k9No_-adbxmkPJ6oiQUOFM73wg@mail.gmail.com>
Subject: Re: [PATCHv3] Generic Mailbox API
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Craig McGeachie <slapdau@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>, courtney.cavin@sonymobile.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:33 AM, Craig McGeachie <slapdau@yahoo.com.au> wrote:
> On 16/02/14 07:22, Jassi Brar wrote:
>>
>> Hello,
>>
>>    Here is what the generic mailbox api looks like after modifications
>> to make it work with 5 different platforms.
>>   Major feedback from Suman Anna(TI), LeyFoon Tan(Intel),
>> Craig McGeachie(Broadcom) and Loic Pallardy(ST).
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>>
>
> Um, sorry for not having included this in the previous email.  I've just
> looked over the patch set and I don't believe it contains anything that I
> did, so I don't think my name is appropriate here at all.
>
I did not assign you copyright/ownership of any code. The patches say
who did what.
I just mentioned on the record that I got very useful feedback from
these guys to improve the api. I do not 'accuse' you of writing any
code ;)  but I am thankful that you in a way tested the api by writing
a driver for it.

Thanks,
Jassi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBQGCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:02:46 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53804 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaBQGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <5301A4DC.4020208@yahoo.com.au>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
	<5301A4DC.4020208@yahoo.com.au>
Date: Mon, 17 Feb 2014 11:32:43 +0530
Message-ID: <CAJe_ZhfjaiVxC_AX48KMdMA6XQqLcAJMd2A1GyLDP8e=ihZrVg@mail.gmail.com>
Subject: Re: [PATCHv3] Generic Mailbox API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Craig McGeachie <slapdau@yahoo.com.au>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2014 11:27, Craig McGeachie <slapdau@yahoo.com.au> wrote:
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
> Important point of clarification.  I don't work for Broadcom.  I have no
> current or past affiliation with Broadcom.  I was fairly certain that I'd
> given no indication that I did.  I'm just some guy who purchased a single
> board computer based on one of their products.  I do work for an IT company,
> but that isn't relevant to what I do after hours on my own time.
>
I saw the Broadcom driver being worked upon by you and assumed you
either work for or on contract with Broadcom. It doesn't matter much
anyways by virtue of the beauty of open-source :)
 So you still have a say on the mailbox code.

Thanks
Jassi

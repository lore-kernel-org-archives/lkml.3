Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3A0TiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:38:12 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:57874 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3A0TiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:38:10 -0500
MIME-Version: 1.0
In-Reply-To: <51057DA7.7040907@zytor.com>
References: <510579C1.3000800@zytor.com>
	<1359313804.10797.74.camel@shinybook.infradead.org>
	<51057DA7.7040907@zytor.com>
Date: Sun, 27 Jan 2013 11:38:09 -0800
X-Google-Sender-Auth: Q1IsBuyWx09xr0ShIa_ky6qIl2g
Message-ID: <CAE9FiQUFZwmiBgYwsoLZ4O+f_w-V01Eb8_6L4ZrHeA4DfLJd8A@mail.gmail.com>
Subject: Re: bzImage 2.12
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 11:19 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I think we can probably do that, since it doesn't affect anything non-broken
> at this point.  I'm sorting out what can be done for 3.8 vs 3.9 at this
> point.
>
> Anyway, as you can tell I'm spending this weekend working for a reason.
>
> It turns out the patch I sent out doesn't actually build.  Here is an
> updated patch.  Can I get your ack for this so I can do the appropriate
> hacks to your and Yinghai's patchsets?

Acked-by: Yinghai Lu <yinghai@kernel.org>

Do you want to me to update my patchset on top it and resend?

or you are going to sort it out by you self?

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaGNESL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:18:11 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:38191 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaGNER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ5Y-eYPffYQ57ERODyBYYKjL2FVhGapKmP0YxzcT9rswfaJaA@mail.gmail.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
	<CAJ5Y-eYPffYQ57ERODyBYYKjL2FVhGapKmP0YxzcT9rswfaJaA@mail.gmail.com>
Date: Mon, 14 Jul 2014 09:47:57 +0530
Message-ID: <CAJe_Zhe5W4D+TzyfKdE8KvSc8SJwyHG3SQGpUyd8-ML-wHBDyg@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        "Mollie.Wu" <Mollie.Wu@tw.fujitsu.com>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 17:16, Ashwin Chaugule <ashwin.chaugule@linaro.org> wrote:
> Hi Jassi,
>
> Other than a few nits, this looks good to me.
>
Thanks for the nits. I will club them together with other feedback on
the patchset.

>
> Hopefully you've run this through checkpatch as well? Also, were you
> able to sort out the process of getting this stuff hosted on Linaro's
> git servers? or elsewhere? It would really help maintainers to pick
> this up and for others to rebase on top of your changes.
>
I didn't think it was a good idea to keep a 'dev-branch' for a new
subsystem before having even a single Ack or Reviewed-by.  Users
should track patch revisions on mailing lists and later maintainers
will be sent a tree:branch to pick Acked patches from.

Cheers,
Jassi

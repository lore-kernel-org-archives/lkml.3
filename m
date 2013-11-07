Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3KGHcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:32:46 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36261 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3KGHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <1383760556.7940.28.camel@joe-AO722>
References: <1383684000.4387.42.camel@joe-AO722>
	<CAFSJ42YQy96Sko8CuG9BGjHzTV7TkRp2=NVt036APxSKpPB=Ag@mail.gmail.com>
	<1383760556.7940.28.camel@joe-AO722>
Date: Thu, 7 Nov 2013 07:32:37 +0000
Message-ID: <CAFSJ42Y-3BZqj+JRNa8wdxjnm1fguD8ToH5Oj0m56yT5NexdVQ@mail.gmail.com>
Subject: Re: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx <wcn36xx@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath5k-devel@venema.h4ckr.net,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>, ath10k@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

I personally like the idea of making some kind of framework on top of
printing because all ath drivers are using the same printing approach
and combining all that code in one place will reduce amount of code in
each particular driver. As a true engineer i like when it's less code
= less work to do = less bugs:)

Suggestion is to send a patch with semicolon fix only and have a
second round of convincing ath guys to change printing code. How does
that sound?

On Wed, Nov 6, 2013 at 5:55 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2013-11-06 at 07:49 +0000, Eugene Krasnikov wrote:
>> Hm... when it comes to semicolon the patch seems to be good. When it
>> comes to dynamic debugging i think we should have a separate
>> discussion about that.
>> I personally like the whole idea about dynamic debug but if you want
>> to change it i would suggest to have some kind of framework for all
>> ath drivers(or maybe all wireless drivers). Because obviously you can
>> find common code in every driver that defines it's own debug
>> functions/debug levels and so on. Why not to make a framework with
>> standard API/levels?
>
> You need to bring that up with the Atheros folk.
> I've tried.  The view seemed to be it was more
> trouble than it was worth.
>
>
>



-- 
Best regards,
Eugene

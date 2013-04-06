Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3DFHIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 03:08:37 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62096 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab3DFHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 03:08:36 -0400
MIME-Version: 1.0
In-Reply-To: <8762008auk.fsf@purkki.adurom.net>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
	<201304051903.11215.chunkeey@googlemail.com>
	<CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
	<8762008auk.fsf@purkki.adurom.net>
Date: Sat, 6 Apr 2013 00:08:34 -0700
X-Google-Sender-Auth: MbXPQ25-shQii6_MaWCNGQAXgXk
Message-ID: <CAJ-VmomQaYFMR0G1DM+dno6qB+AdXUom8=kWPzJoOjuzQj81bw@mail.gmail.com>
Subject: Re: Version number policy!
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 22:52, Kalle Valo <kvalo@adurom.com> wrote:
> Eugene Krasnikov <k.eugene.e@gmail.com> writes:
>
>> Good point regarding timestamp.
>>
>> When it comes to feature bitmap do you have an example of such a
>> bitmap from carl9170? Why not to rely always on major version?
>
> I'm with Christian here. In ath6kl we switched to firmware advertising
> feature capabilities and I have never looked back, it's so much easier.
> You don't need to do any mapping between firmware versions and features,
> you just deal one feature at a time.

Ok. Well, we've got plenty of time to finalise this before things get
established. There's still plenty of tidying up to do before we start
pushing in new features.

Thanks for all your feedback so far!



Adrian

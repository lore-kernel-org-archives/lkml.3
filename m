Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767Ab3DHJKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:10:34 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57401 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934539Ab3DHJKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomQaYFMR0G1DM+dno6qB+AdXUom8=kWPzJoOjuzQj81bw@mail.gmail.com>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com>
	<CAB=NE6V3sApMSGWkKbaFaJC4+VpLxgYF-xyNRKxiA-YDCwhGkQ@mail.gmail.com>
	<201304051903.11215.chunkeey@googlemail.com>
	<CAFSJ42bqquh+xekt8+V3wbG3MOUVFELTxR3mNPfS0Jn9J7OURQ@mail.gmail.com>
	<8762008auk.fsf@purkki.adurom.net>
	<CAJ-VmomQaYFMR0G1DM+dno6qB+AdXUom8=kWPzJoOjuzQj81bw@mail.gmail.com>
Date: Mon, 8 Apr 2013 11:10:30 +0200
Message-ID: <CAFSJ42Zd3s8xKwt4X3LNcupCTntDULxNntMuD-_Xh6_csiGA4A@mail.gmail.com>
Subject: Re: Version number policy!
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Kalle Valo <kvalo@adurom.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanx Christian for a valuable input.

It’s a good idea to pack bitmap into the tail/header of the firmware
binary to get capabilities even before fw loading. The plan is to add
8 bytes for caps and also add time stamp. Let me play around with that
and provide fw and driver patch for review.

2013/4/6 Adrian Chadd <adrian@freebsd.org>:
> On 5 April 2013 22:52, Kalle Valo <kvalo@adurom.com> wrote:
>> Eugene Krasnikov <k.eugene.e@gmail.com> writes:
>>
>>> Good point regarding timestamp.
>>>
>>> When it comes to feature bitmap do you have an example of such a
>>> bitmap from carl9170? Why not to rely always on major version?
>>
>> I'm with Christian here. In ath6kl we switched to firmware advertising
>> feature capabilities and I have never looked back, it's so much easier.
>> You don't need to do any mapping between firmware versions and features,
>> you just deal one feature at a time.
>
> Ok. Well, we've got plenty of time to finalise this before things get
> established. There's still plenty of tidying up to do before we start
> pushing in new features.
>
> Thanks for all your feedback so far!
>
>
>
> Adrian



-- 
Best regards,
Eugene

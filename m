Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3JNO62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:58:28 -0400
Received: from host171.canaca.com ([67.55.55.225]:60208 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3JNO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:58:27 -0400
Message-ID: <d241ee8c4a607eebd06cfdf5b04ab200.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1310141602540.12405@pobox.suse.cz>
References: <alpine.LNX.2.00.1310101002120.13289@pobox.suse.cz>
    <1381414814-2107-1-git-send-email-simon@mungewell.org>
    <1381414814-2107-3-git-send-email-simon@mungewell.org>
    <CADbOyBQodqzSb04OCO6oduJSZvveZXxQjSdp+CdyKKk5Bs=O7w@mail.gmail.com>
    <alpine.LNX.2.00.1310141602540.12405@pobox.suse.cz>
Date: Mon, 14 Oct 2013 10:58:21 -0400
Subject: Re: [PATCHv2 3/3] HID:Kconfig: Correct MOMO description in wrong
 place (handled by LG4FF).
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Elias Vanderstuyft" <elias.vds@gmail.com>,
        "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?=22Michal_Mal=FD=22?= <madcatxster@prifuk.cz>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 10 Oct 2013, Elias Vanderstuyft wrote:
>
>> I don't see any report-descriptor being fixed up, this results in having
>> only two axes: steering and combined accel-brake axis.
>> So, same procedure as the Formula Vibration wheel, I'll send you the
>> report
>> descriptor and some hidraw data when using the accel and brake pedals,
>> in
>> my next mail.
>
> So should I wait for v3, where the rdesc fixup for splitting the axes will
> be done, or are you planning to submit it to me as a followup patch?

The HID descriptor for the MOMO Black was re-written in part2 of the patch
series:
https://patchwork.kernel.org/patch/3016111/

Simon


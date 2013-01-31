Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3AaQQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:16:01 -0500
Received: from host171.canaca.com ([67.55.55.225]:52688 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3AaQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:15:58 -0500
Message-ID: <24729db4d06b0a7e8192fc7a137dabc2.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1301311653090.23853@pobox.suse.cz>
References: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
    <1359644830-3274-1-git-send-email-simon@mungewell.org>
    <alpine.LNX.2.00.1301311622430.23853@pobox.suse.cz>
    <16fadf665c1103c5f3184d9f4471d415.squirrel@mungewell.org>
    <alpine.LNX.2.00.1301311653090.23853@pobox.suse.cz>
Date: Thu, 31 Jan 2013 11:15:57 -0500
Subject: Re: [PATCH 1/5] USB: HID: SRW-S1 Gaming Wheel Driver
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rosegardener@freeode.co.uk
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

> On Thu, 31 Jan 2013, simon@mungewell.org wrote:
>
>> > I thought we converged to hid-steelseries name in the end originally?
>> >
>> > If you agree, I'll change it and apply.
>>
>> I'd be OK with that,
>
> Thanks. I will also apply this patch on top, otherwise we'll be corrupting
> memory in steelseries_srws1_probe() here:
>
> 	drv_data->led[SRWS1_NUMBER_LEDS] = led;
>


You are correct.

Bugger! I had that in the original patch, but must have missed it when
copying over to new file name.

Thanks,
Simon.


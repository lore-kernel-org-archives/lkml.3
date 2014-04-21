Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaDULZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:25:13 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49909 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaDULZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <9307026b9160edfb785b894fe6d539b7.squirrel@mungewell.org>
References: <1609685.QRL9N9sQvX@sigyn>
	<c49c4ad2bfabfe75ac065f8ad878d697.squirrel@mungewell.org>
	<CADbOyBSxHj80zA7UNq+yAtmSPgTqCXgOUUsQ30DQQ66cGw9egw@mail.gmail.com>
	<9307026b9160edfb785b894fe6d539b7.squirrel@mungewell.org>
Date: Mon, 21 Apr 2014 13:25:09 +0200
Message-ID: <CADbOyBRDbScJ-gG=vqc4boq8kkuJ_9Xt_6Kt5MkgbcTy2Mbvpw@mail.gmail.com>
Subject: Re: [PATCH 0/24] Introduce ff-memless-next as an improved replacement
 for ff-memless
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Simon Wood <simon@mungewell.org>
Cc: =?UTF-8?B?TWljaGFsIE1hbMODwr0=?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:29 AM,  <simon@mungewell.org> wrote:
>
>> Did the WiiWheel have working FF_CONSTANT before this patchset?
>> It would be weird if yes, because lg4ff is also used for MOMO-Black
>> which works fine.
>
> Yes, I think that the force requested by fftest was just too weak to
> actually move the wheel. ffcfstress (or whatever it is called) works OK.

Ah, nice to hear.

I had some additional questions that might benefit to the porting of
the lgff and sony driver, concerning the optimal value for
FF_UPDATE_RATE (at the moment it defaults to a safe 50ms):
- Could you try to sniff FF command USB traffic with the Windows
driver of the WingMan Force, just to learn what the update interval is
when playing a ConstantForce effect with an envelope (I'm only
interested in the envelope part)?
- If official/decent Windows drivers are present for one of the Sony
controllers you have, can you please do the same, but now when playing
a vibration effect (using XInput)?

Elias

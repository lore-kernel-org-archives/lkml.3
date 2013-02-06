Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3BFN2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:28:37 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51262 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3BFN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1302061410230.16860@pobox.suse.cz>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
	<20130203130731.GA2677@polaris.bitmath.org>
	<CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com>
	<20130204115443.GA4405@polaris.bitmath.org>
	<alpine.LNX.2.00.1302051212550.2260@pobox.suse.cz>
	<CAN+gG=F5KHmq2F_op6RbvXiSp=T0oD_cTgPuBHptXVHyHZwpjA@mail.gmail.com>
	<alpine.LNX.2.00.1302061410230.16860@pobox.suse.cz>
Date: Wed, 6 Feb 2013 14:28:32 +0100
Message-ID: <CAN+gG=GReDsW_xKm9uLwfAkA6SPzUi9anaojESqSTx+nPKOdqQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Do you mind if I send the usbhid dependency and the pen+multitouch
>> series this week, or we are too close to the 3.9 opening window?
>
> Please just send the patches, and let's see whether they will make it for
> 3.8 or I'll queue (some of) them for 3.9.
>

Well, I didn't wanted to push them into 3.8 (the rc6 is already there,
and I doubt Linus would be happy to see a lot of patches now). I was
asking if it was not too late to schedule them for 3.9, or if you'd
rather wait for 3.10 :)

Anyway, I'm doing my best to push them soon.

Cheers,
Benjamin

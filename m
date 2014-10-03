Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaJCOpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:45:18 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34648 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaJCOpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1410031308360.14259@pobox.suse.cz>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1410011016160.26311@pobox.suse.cz> <20141001131008.GB18756@mail.corp.redhat.com>
 <CAG_cf+fYGATBL9Sgvvp7CaScP112fiqiyuR0gBdkS-424S3Kog@mail.gmail.com> <alpine.LNX.2.00.1410031308360.14259@pobox.suse.cz>
From: Andrew de los Reyes <andrew-vger@gizmolabs.org>
Date: Fri, 3 Oct 2014 07:44:51 -0700
X-Google-Sender-Auth: azkuPKIcwr9gYE5XTWtlfz-hCj0
Message-ID: <CAG_cf+cO5wiPxygxg_aQL9cJ5hichxiOart0A1TsCr_LymswBA@mail.gmail.com>
Subject: Re: [PATCH 00/13] HID: add support of Logitech touchpads and special devices
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-kernel@vger.kernel.org,
        Linux Input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, but I would prefer to use my chromium account:

Tested-by: Andrew de los Reyes <adlr@chromium.org>

On Fri, Oct 3, 2014 at 4:09 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 2 Oct 2014, Andrew de los Reyes wrote:
>
>> I've tested these patches successfully on a Chromebook Pixel with the
>> following devices:
>>
>> - T650 touchpad
>> - TK820 keyboard/touchpad
>> - Original WTP touchpad
>>
>> I also tested a touch mouse and as expected it continued to function
>> as a plain USB mouse. The TK820 was indeed broken into two devices,
>> with autorepeat enabled for the keyboard only. The other two devices
>> behaved as expected with no perceived regressions.
>>
>> In short, from a functionality perspective I'm happy with these
>> patches. I will let others discuss code structure.
>
> Thank you. Can I use
>
>         Tested-by: Andrew de los Reyes <andrew-vger@gizmolabs.org>
>
> once / if I am merging this patchset?
>
> --
> Jiri Kosina
> SUSE Labs

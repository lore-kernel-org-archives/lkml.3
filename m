Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaLQB3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:29:11 -0500
Received: from lekensteyn.nl ([178.21.112.251]:35785 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLQB3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:29:08 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
Date: Wed, 17 Dec 2014 02:28:53 +0100
Message-ID: <1754756.J50LHtmV20@al>
User-Agent: KMail/4.14.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAN+gG=F0HhzXQhsaHTEb5Hy2CVTsoOSopCt4grXFnSKt+tPsWw@mail.gmail.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com> <CAN+gG=F0HhzXQhsaHTEb5Hy2CVTsoOSopCt4grXFnSKt+tPsWw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Tuesday 16 December 2014 17:13:05 Benjamin Tissoires wrote:
> the logitech patches are queuing up really fast.
> To keep track of them, I made a bundle on patchwork:
> https://patchwork.kernel.org/bundle/bentiss/hid-logitech-hidpp/
> (/me discovered a new tool to play with)
> 
> Right now, the patch "HID: logitech-hidpp: detect HID++ 2.0 errors
> too" is waiting for Logitech's approval, and the 2 of this series need
> review.
> 
> Peter, please tell me if I missed one patch.
 
Nice, it would be even better if a bundle could be bookmarked, or if a
group could set review flags in this bundle :-)

There are no missing patches from my side. All changes (based on
jikos/hid, branch for-next) are at
https://git.lekensteyn.nl/peter/linux/log/?h=logitech-hidpp
and are tested in QEMU with an emulated device and a real device (with
T400/T650/M525 paired).

I noticed that all devices would immediately get an input device (even
if they were off), except for the T650. This apparently happens because
the touchpad configuration cannot be retrieved or when the touchpad
cannot be put in raw reporting mode. I cannot think of something to
"fix" this though.
-- 
Kind regards,
Peter
https://lekensteyn.nl


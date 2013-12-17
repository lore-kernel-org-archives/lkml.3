Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3LQQfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:35:01 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34803 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:34:59 -0500
MIME-Version: 1.0
In-Reply-To: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
Date: Tue, 17 Dec 2013 17:34:56 +0100
Message-ID: <CANq1E4SDwSQuvBstC-xMhtsUwm8kWwy2fXTJwOfC09gwsLnnZQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Input: ABS2 and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Input Tools <input-tools@lists.freedesktop.org>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Dec 17, 2013 at 4:48 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> This implements the recently discussed ABS2 API. It's working fine on my machine
> with libevdev. Comments welcome!
>
> * Patch #1 fixes some uinput shortcomings and prepares uinput for ABS2
> * Patch #2 adds ABS2
> * Patch #3 is just a small comment-fix for #4
> * Patch #4 adds some new example ABS values in the new range
>
> Note that I have patches pending which make use of the new ABS values, but I'd
> like to get this reduced series in first.

If someone is interested in the libevdev patches, see here:
  http://cgit.freedesktop.org/~dvdhrm/libevdev/log/?h=abs2

I tested the libevdev test-suite in all combinations linux+libevdev,
linux-abs2 + libevdev, linux + libevdev-abs2, linux-abs2 +
libevdev-abs2 and all worked fine.

Thanks
David

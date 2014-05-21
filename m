Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaEUOxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:53:37 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44974 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaEUOxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <537BCB63.1020200@logitech.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
	<2965006.XKYHWj9YzJ@sigyn>
	<537B9FAE.9070602@logitech.com>
	<10859911.6zyzadbfH9@sigyn>
	<537BCB63.1020200@logitech.com>
Date: Wed, 21 May 2014 16:53:34 +0200
Message-ID: <CADbOyBQxC+Epv1kz8jsBKNgYGFO0R-UPBXvn_qV8Sqb6rNw+Og@mail.gmail.com>
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: Roland Bosa <rbosa@logitech.com>
Cc: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Anssi Hannula <anssi.hannula@iki.fi>,
        Simon Wood <simon@mungewell.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:38 PM, Roland Bosa <rbosa@logitech.com> wrote:
> On 05/20/2014 12:00 PM, Michal Malı wrote:
> There's a healthy amount of
> code in the Windows driver that you would call 'quirks' which deals with
> deciding how to allocate multiple springs and dampers to a single slot.

But 2 Spring effects with different offsets and non-zero effective
force can't be combined into a single slot (without streaming them
with Constant force), right?

> Sometimes, even the springs and dampers are being streamed in via the
> constants force, but that requires (as you pointed out earlier) a fast
> update rate and some "smartness"

OK, is this method used when all force-slots are already full?
Or is it only used for some specific (restricted) devices, such as
devices with only 2 force slots?

And in this case, is the position of the device monitored at a speed
higher than 8ms, in order to keep the feedback-loop stable?

Thanks,
Elias

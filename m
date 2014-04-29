Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbaD2IHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:07:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56320 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaD2IG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140424052719.GA29764@core.coreip.homeip.net>
References: <20140424052719.GA29764@core.coreip.homeip.net>
Date: Tue, 29 Apr 2014 10:06:57 +0200
Message-ID: <CANq1E4TF_LpG2bbTrB3dbQEVL+x4yKAtjoGEZw_t_9MmAYyFWw@mail.gmail.com>
Subject: Re: [PATCH] Input: evdev - get rid of old workaround for EVIOCGBIT
From: David Herrmann <dh.herrmann@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Apr 24, 2014 at 7:27 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> We put this workaround in 2008 and the offending userspace has been fixed
> up long time ago; the link in the message is no longer valid either, so it
> is time to retire it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Yes, pleeeease!

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

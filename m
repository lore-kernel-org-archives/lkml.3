Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3IKA0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:26:16 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35061 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3IKA0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:26:14 -0400
Message-ID: <522FB8A2.7070608@gmail.com>
Date: Wed, 11 Sep 2013 10:26:10 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uinput: Use input_inject_event in uinput_inject_event
References: <1378855973-11595-1-git-send-email-rmallon@gmail.com> <1378855973-11595-2-git-send-email-rmallon@gmail.com> <20130911001235.GA5840@core.coreip.homeip.net>
In-Reply-To: <20130911001235.GA5840@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/13 10:12, Dmitry Torokhov wrote:
> Hi Ryan,
> 
> On Wed, Sep 11, 2013 at 09:32:53AM +1000, Ryan Mallon wrote:
>> Call input_inject_event rather than input_event in uinput_inject_event. This
>> mirrors the behaviour of evdev_write. input_inject_event will ignore the
>> injected event if the uinput input device has been grabbed for exclusive
>> access by a handler other than uinput.
> 
> uinput is not an input handler but input driver and therefore should
> continue using input_event().

Ah, I wasn't sure about this, which is why I broke it out into a
separate patch. Sorry for the noise.

~Ryan



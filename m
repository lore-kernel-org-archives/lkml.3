Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3IKAMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:12:42 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59322 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IKAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:12:40 -0400
Date: Tue, 10 Sep 2013 17:12:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: rydberg@euromail.se, carl@ok-labs.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uinput: Use input_inject_event in uinput_inject_event
Message-ID: <20130911001235.GA5840@core.coreip.homeip.net>
References: <1378855973-11595-1-git-send-email-rmallon@gmail.com>
 <1378855973-11595-2-git-send-email-rmallon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378855973-11595-2-git-send-email-rmallon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Wed, Sep 11, 2013 at 09:32:53AM +1000, Ryan Mallon wrote:
> Call input_inject_event rather than input_event in uinput_inject_event. This
> mirrors the behaviour of evdev_write. input_inject_event will ignore the
> injected event if the uinput input device has been grabbed for exclusive
> access by a handler other than uinput.

uinput is not an input handler but input driver and therefore should
continue using input_event().

Thanks.

-- 
Dmitry

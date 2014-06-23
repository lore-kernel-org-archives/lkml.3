Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaFWQUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:20:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46011 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaFWQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140623144255.GA19911@localhost>
References: <20140618073950.GC31163@localhost>
	<1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
	<1403534113.10017.22.camel@linux-fkkt.site>
	<20140623144255.GA19911@localhost>
Date: Mon, 23 Jun 2014 19:20:02 +0300
Message-ID: <CAEEjW06gnsrvGteHSGT=7URKrKVzLSOodzgupcN-+DU6xzMS6A@mail.gmail.com>
Subject: Re: [PATCH v9] leds: USB: HID: Add support for MSI GT683R led panels
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sorry for noticing this thread late.

No problem. Good that you noticed it now! Thank you.

> Just move the initialisation of the lock and work to the other private
> data initialisations directly after it's allocated.
>
> Can you send a follow up patch, Janne?

Yes I can. Just a moment.

Janne

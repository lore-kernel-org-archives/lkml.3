Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaGCI3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:29:14 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:33452 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaGCI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:29:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 3 Jul 2014 10:28:30 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, cooloney@gmail.com, jkosina@suse.cz, greg@kroah.com,
        bjorn@mork.no, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v5] HID: leds: move led_mode attribute to led-class
 devices in MSI GT683R driver
Message-ID: <20140703082830.GB16590@localhost>
References: <20140701201627.GA30605@localhost>
 <1404322679-19521-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404322679-19521-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 08:37:59PM +0300, Janne Kanniainen wrote:
> Move led_mode attribute from HID device to led-class devices. This will also fix race condition by using attribute-groups.
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>

Looks good now. Thanks!

Perhaps you can resend both patches as a series (call both v6) so it's
easy to figure which version that is to be applied.

I also noticed that your subject line is a bit long (will end up as the
commit summary). Using for example

	HID: gt683r: move mode attribute to led-class devices

would make it more concise.

Oh, and your commit message lacks line breaks (around 72 cols). You
could fix that as well.

Thanks again,
Johan

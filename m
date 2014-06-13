Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaFMRTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:19:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61021 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaFMRT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140613075411.GG10940@localhost>
References: <20140612090636.GK10256@localhost>
	<1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
	<20140613075411.GG10940@localhost>
Date: Fri, 13 Jun 2014 20:19:26 +0300
Message-ID: <CAEEjW05PL7ZqnKypCYP4SP9hzKeDii=GouHLJ2u5xtR0yCTO2w@mail.gmail.com>
Subject: Re: [PATCH v5] leds: USB: HID: Add support for MSI GT683R led panels
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, so you decided to continue setting mode on every LED brightness
> update. That should be fine, but you never answered my question about
> whether it is necessary?

I decided to do it that way because official driver did it as well. I
can check if it is necessary.

> You're almost done. One last update? :)

Yeah, I hope so :)

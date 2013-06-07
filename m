Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3FGJ4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:56:09 -0400
Received: from linuxdingsda.de ([87.106.20.67]:59870 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752273Ab3FGJ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:56:05 -0400
Message-ID: <51B1AE2F.3040405@linuxdingsda.de>
Date: Fri, 07 Jun 2013 11:55:59 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?windows-1252?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Increase the number of USB to serial devices we
 can support at once
References: <20130606173103.GA1812@kroah.com> <51B176FB.9070509@linuxdingsda.de>
In-Reply-To: <51B176FB.9070509@linuxdingsda.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 08:00 AM, Tobias Winter wrote:
>   CC      drivers/usb/serial/console.o
> drivers/usb/serial/console.c: In function ‘usb_console_setup’:
> drivers/usb/serial/console.c:111:2: error: implicit declaration of
> function ‘usb_serial_get_by_index’ [-Werror=implicit-function-declaration]
> drivers/usb/serial/console.c:111:9: warning: assignment makes pointer
> from integer without a cast [enabled by default]
> drivers/usb/serial/console.c:122:40: error: ‘struct usb_serial’ has no
> member named ‘minor’
> cc1: some warnings being treated as errors
> make[4]: *** [drivers/usb/serial/console.o] Error 1
> make[3]: *** [drivers/usb/serial] Error 2
> make[2]: *** [drivers/usb] Error 2
> make[1]: *** [drivers] Error 2
> make[1]: Leaving directory `/root/usb.git'
> make: *** [debian/stamp/build/kernel] Error 2

Despite that broken driver, I just gave it a try and the patchset works
as expected.

Thanks

Tobias

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3GVWIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 18:08:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23908 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3GVWIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 18:08:15 -0400
From: "Gujare, Rupesh" <Rupesh.Gujare@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Joe Perches <joe@perches.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] staging: ozwpan: Rename Kbuild to Makefile
Thread-Topic: [PATCH v2 5/5] staging: ozwpan: Rename Kbuild to Makefile
Thread-Index: AQHOeLMoWq/8C+NN8U6KBLZZjuSXBJlUZpKAgBydKgD///KrgIAAZbnU
Date: Mon, 22 Jul 2013 22:08:10 +0000
Message-ID: <CB57019DFBA97B45884DCA732411B955341F1FFE@hnombx02.corp.atmel.com>
References: <1372255013.2076.4.camel@joe-AO722>
 <1372941331-9586-6-git-send-email-rupesh.gujare@atmel.com>
 <51D56E6B.1000605@atmel.com>
 <51ED6F36.8060308@atmel.com>,<20130722175535.GA3682@kroah.com>
In-Reply-To: <20130722175535.GA3682@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.161.30.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Greg Kroah-Hartman [gregkh@linuxfoundation.org]
Sent: 22 July 2013 18:55
To: Gujare, Rupesh
Cc: devel@linuxdriverproject.org; Joe Perches; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] staging: ozwpan: Rename Kbuild to Makefile

On Mon, Jul 22, 2013 at 06:43:18PM +0100, Rupesh Gujare wrote:
> Greg,
>
> Can I expect to merge following patch series with your tree ?
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-July/039354.html
>
> Or do you want me to rework on it as per your suggestions here :-
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-June/039278.html

At the least, please rework them as Joe asked you to, why haven't you
done that?

And yes, ideally I'd like to see my suggestion implemented as well.

All right, I will resend patch series with detailed commit log.
However previous patch series (From Joe) adds new macro on top of pr_dbg() & netdev_dbg(). Is that all right ?

I believe rest of your suggestions are already included in above patch series. 
Please let me know if I have missed anything here.

--
Regards,
Rupesh Gujare
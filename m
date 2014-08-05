Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaHEQBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbaHEQBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:01:37 -0400
Message-ID: <1407254453.8792.4.camel@dcbw.local>
Subject: Re: [PATCH] serial/option: Add support for Option GTM671WFS
From: Dan Williams <dcbw@redhat.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 11:00:53 -0500
In-Reply-To: <CAPybu_3rpyreJUDimeAzieB9nRYjJ-iu60fMfq3zs+SmhNyt7A@mail.gmail.com>
References: <1406894424-7561-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1406913373.10668.5.camel@dcbw.local>
	 <CAPybu_3rpyreJUDimeAzieB9nRYjJ-iu60fMfq3zs+SmhNyt7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 11:12 +0200, Ricardo Ribalda Delgado wrote:
> Hello Dan
> 
> >
> > Are you 100% sure these don't go into the 'hso' driver?  'option' is
> > used for mostly older Option devices (like 5+ years old).  I tried to
> > find information about this module, and the closest I could come for
> > 0af0:9200 was:
> >
> > http://trac.gateworks.com/wiki/3g
> >
> > which indicates they might be 'hso' instead.  Can you give that a try?

Follow-up note: this device should indeed be driven by 'hso' (not
option) and Ricardo has submitted a patch for that to netdev@.

Dan

> With all the hso_ids configuration I get the following error message:
> 
> [  553.501693] hso: drivers/net/usb/hso.c: Option Wireless
> [  553.524898] hso 2-1.4:1.7: Not our interface
> 
> and depending on the mode I get 3, 4 or 6 ttySH interfaces
> 
> But, if we ignore this, the device can connect to the internet with
> hso_connect.sh. I have already post a patch using the hso driver.
> 
> The device could also connect with option.ko... Do you think that
> there could be other devices wrongly handled with option ?
> 
> Ricardo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



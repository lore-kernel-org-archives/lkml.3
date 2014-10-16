Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaJPNUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:20:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaJPNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:20:06 -0400
Date: Thu, 16 Oct 2014 15:19:01 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Div-by-zero in the 8250 serial driver (3.17-rc5)
Message-ID: <20141016131901.GA5501@kroah.com>
References: <CAP145pg75hFKi2S9SVywRfex_A5=yRpe0p4Dzri8+Q=7YWoXfg@mail.gmail.com>
 <541C27E8.6090000@hurleysoftware.com>
 <543FC31E.3000702@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543FC31E.3000702@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 09:07:42AM -0400, Peter Hurley wrote:
> Hi Greg,
> 
> I noticed this patch didn't make it into 3.18-rc1 or -next.
> Do I need to resend this?

Ugh, sorry about that, I think it got buried in the thread.  Please
always resend things like this in a patch-form that I can apply it
without having to edit the email by hand.

So yes, please resend, I'll get it into an early -rc release.  And is
this needed for 3.17-stable and prior?

thanks,

greg k-h

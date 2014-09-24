Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaIXIdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:33:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46778 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaIXIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:33:03 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 10:30:29 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Johan Hovold <johan@kernel.org>, Andreas Bomholtz <andreas@seluxit.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Added support for Seluxit USB dongle to cp210x
 driver.
Message-ID: <20140924083029.GB15878@localhost>
References: <1411372243-23933-1-git-send-email-andreas@seluxit.com>
 <20140922085256.GB5237@localhost>
 <20140924044448.GA6240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924044448.GA6240@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:44:48PM -0700, Greg Kroah-Hartman wrote:
> On Mon, Sep 22, 2014 at 10:52:56AM +0200, Johan Hovold wrote:
> > On Mon, Sep 22, 2014 at 09:50:43AM +0200, Andreas Bomholtz wrote:
> > > Added the Seluxit ApS USB Serial Dongle to cp210x driver.
> > > 
> > > Signed-off-by: Andreas Bomholtz <andreas@seluxit.com>
> > > ---
> > 
> > Thanks for resending. Applied just fine now.
> 
> Was this in the last pull request you made to me?  I don't see it
> there...

I just sent you a final pull request for 3.17. Just two device ids,
including this one.

Johan

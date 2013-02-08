Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3BHEHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:07:11 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64621 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784Ab3BHEHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <5111431D.8070906@ahsoftware.de>
References: <51071E21.9030008@ahsoftware.de>
	<5107A5ED.7020009@ahsoftware.de>
	<5107AE4F.9000809@ahsoftware.de>
	<5107F014.4030704@ahsoftware.de>
	<5108329E.2050802@ahsoftware.de>
	<20130204011413.GA6413@kroah.com>
	<510FA409.2080201@ahsoftware.de>
	<51100930.6080405@ahsoftware.de>
	<20130204192514.GA32318@kroah.com>
	<5110AFEC.8020406@ahsoftware.de>
	<20130205172245.GA1426@kroah.com>
	<5111431D.8070906@ahsoftware.de>
Date: Fri, 8 Feb 2013 14:07:05 +1000
Message-ID: <CAPM=9tzNeQTXAmvZZ1RCmn6uTYHvweYKKnSPYAh7QYRGNMgeUw@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
From: Dave Airlie <airlied@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> But I've just switched to udl (instead of udlfb) and will see if I can fix
> the bugs there to make it usable as a console. udl is a rewrite of udlfb
> with some additional features (e.g. drm), so hopefully fixing the remaining
> problems there will require less work.

I may have fixed the major udl problem with being a console, patch was
posted to dri-devel yesterday, and I've pushed it into -next.

Dave.

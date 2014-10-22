Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaJVNVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:21:06 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37583 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaJVNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:21:04 -0400
Date: Wed, 22 Oct 2014 14:20:16 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, Greg KH <greg@kroah.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Touch processing on host CPU
Message-ID: <20141022142016.42e8032c@alan.etchedpixels.co.uk>
In-Reply-To: <54468E0D.2010200@itdev.co.uk>
References: <5440F282.8040306@itdev.co.uk>
	<20141017171756.GA22238@dtor-ws>
	<20141021132229.37a1197c@alan.etchedpixels.co.uk>
	<54468E0D.2010200@itdev.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This sounds promising. The only sticking point I can see is that a touch
> frontend has many more channels (possibly thousands), which would seem to
> impose a lot of overhead when put into the IIO framework. I will certainly
> take a closer look at it.

If that is the case then it may not be the right match - but it might
also be a good argument for fixing the IIO layer so it isn't ?

Alan

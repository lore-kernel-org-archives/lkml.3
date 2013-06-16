Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3FPWOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:14:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55650 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3FPWOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:14:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Morales, Alejandra" <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Runtime Power Management
Date: Mon, 17 Jun 2013 00:15:30 +0200
Message-ID: <3436418.fmSDhCQZH6@linux-5eaq.site>
User-Agent: KMail/4.10.3 (Linux/3.7.10-1.11-desktop; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CACVXFVPrb-6WXadXyYE923+1_MA+y-9p1RRO=ufXXJCkEJu+OQ@mail.gmail.com>
References: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de> <CACVXFVPrb-6WXadXyYE923+1_MA+y-9p1RRO=ufXXJCkEJu+OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 June 2013 23:07:36 Ming Lei wrote:
> On Mon, Jun 10, 2013 at 12:28 AM, Morales, Alejandra
> <alejandra.morales@tum.de> wrote:
> 
> > - Is runtime power management supported by net devices?
> 
> Currently, 'struct net_device' doesn't support runtime power management,
> and I submitted one patch to add the support for solving accessing
> suspended device by 'ethtool', but it was rejected.
> 
>               http://marc.info/?t=135054860600003&r=1&w=2

And the discussion is still useful and true.

> But the physical device of the net device can support runtime PM, for example,
> some PCIe network devices support runtime PM on link change, and usbnet
> devices support auto suspend.

There is a design behind runtime PM. Runtime PM is involved if a device looses
capabilities in a power saving state. Or if it is a dependency among runtime PM
of devices. Therefore it is not used for things like Energy Efficient Ethernet.

	Regards
		Oliver


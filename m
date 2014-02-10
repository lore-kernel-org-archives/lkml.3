Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaBJLVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:21:49 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53275 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:21:48 -0500
Date: Mon, 10 Feb 2014 11:21:16 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        dh.herrmann@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv2] tty: Set correct tty name in 'active' sysfs attribute
Message-ID: <20140210112116.010b1006@alan.etchedpixels.co.uk>
In-Reply-To: <CAPXgP11BPt+bcHNELwucyXz+ZticDpZbs1Ae=c0qVeWKb69pnA@mail.gmail.com>
References: <1391696863-62767-1-git-send-email-hare@suse.de>
	<20140206152947.GA19335@kroah.com>
	<52F3ADD4.7020907@suse.de>
	<20140206162908.GA7443@kroah.com>
	<CAPXgP11BPt+bcHNELwucyXz+ZticDpZbs1Ae=c0qVeWKb69pnA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds good to me. The intention clearly was to point to the device in use,
> which we can find then.

I would concur.

> I would not expect problems with this change. For common uses it is the
> same name already and nothing visibly should change, and for the ones
> where it isn't the same, I expect it is not too useful to find the driver
> name.

Very few tools use it so if it doesn't break any distro init setups
(upstart, sysvinit, oh and that other one....) it ought to be fine.

Alan

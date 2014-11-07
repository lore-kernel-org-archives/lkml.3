Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKGJFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:05:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaKGJFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:05:09 -0500
Message-ID: <1415351112.2671.9.camel@linux-0dmf.site>
Subject: Re: [PATCH] USB: cdc-acm: add quirk for control-line state requests
From: Oliver Neukum <oneukum@suse.de>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Nix <nix@esperi.org.uk>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Date: Fri, 07 Nov 2014 10:05:12 +0100
In-Reply-To: <1415293713-3051-1-git-send-email-johan@kernel.org>
References: <20141106170456.GC26196@localhost>
	 <1415293713-3051-1-git-send-email-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 18:08 +0100, Johan Hovold wrote:
> Add new quirk for devices that cannot handle control-line state
> requests.
> 
> Note that we currently send these requests to all devices, regardless
> of
> whether they claim to support it, but that errors are only logged if
> support is claimed.

That makes me wonder whether we should do this. What do you think?

	Regards
		Oliver



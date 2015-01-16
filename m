Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbbAPIKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:10:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbbAPIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:10:13 -0500
Message-ID: <1421395800.15673.0.camel@linux-0dmf.site>
Subject: Re: [PATCH] usb: Fix typo in `struct usb_host_interface' comment
From: Oliver Neukum <oneukum@suse.de>
To: Chris Rorvick <chris@rorvick.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Jan 2015 09:10:00 +0100
In-Reply-To: <CAEUsAPZeK18xBKawK5GVmhxrOwi3ZNOP-x9fUrkdEgWj10tUbw@mail.gmail.com>
References: <1421293948-10901-1-git-send-email-chris@rorvick.com>
	 <1421319786.27673.12.camel@linux-0dmf.site>
	 <CAEUsAPZime72Cu8prsVx8tabcj_KLoJG9V2j3S41S=z2w=acAQ@mail.gmail.com>
	 <CAEUsAPZeK18xBKawK5GVmhxrOwi3ZNOP-x9fUrkdEgWj10tUbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 17:47 -0600, Chris Rorvick wrote:
> I think understand your comment now so I will respond more
> specifically:
> This is a typo precisely because `bNumEndpoint' is not consistent with
> the specification, nor is it consistent with the definition of `struct
> usb_interface_descriptor'.  The specification and the structure both
> use
> `bNumEndpoints'.

Sorry, I stand corrected. The patch is good.

	Regards
		Oliver



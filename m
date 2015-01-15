Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbbAOLDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:03:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbbAOLDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:03:18 -0500
Message-ID: <1421319786.27673.12.camel@linux-0dmf.site>
Subject: Re: [PATCH] usb: Fix typo in `struct usb_host_interface' comment
From: Oliver Neukum <oneukum@suse.de>
To: Chris Rorvick <chris@rorvick.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2015 12:03:06 +0100
In-Reply-To: <1421293948-10901-1-git-send-email-chris@rorvick.com>
References: <1421293948-10901-1-git-send-email-chris@rorvick.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-14 at 21:52 -0600, Chris Rorvick wrote:
> The descriptor member `bNumEndpoints' is plural.

I am afraid that is not a good idea. The name of a
member of a structure mentioned in the specification should
appear as it is used in the specification.

	Regards
		Oliver



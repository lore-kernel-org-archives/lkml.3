Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaJFKiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:38:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaJFKiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:38:19 -0400
Message-ID: <1412591909.1132.9.camel@linux-0dmf.site>
Subject: Re: Displaylink Attached Display Adapater and Monitor Not Recognized
From: Oliver Neukum <oneukum@suse.de>
To: Dennis Gesker <dennis@gesker.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 12:38:29 +0200
In-Reply-To: <CADyGkNRc3dnYfipSNFGj3_r6Y8vuTVsiAbzRB0UWCqqd-9Pf6Q@mail.gmail.com>
References: <CADyGkNRc3dnYfipSNFGj3_r6Y8vuTVsiAbzRB0UWCqqd-9Pf6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 16:36 -0600, Dennis Gesker wrote:
> Displaylink USB 3.0 Attached Display Adapater and Monitor Not Recognized
> DisplayLink Plug and Play Universal docking Station
> DELL
> Model: D3000
> MFG: ACP075US
> SN: 1309017059
> 
> 
> Apologies in advance if I'm posting to the wrong list.

Bugs with USB devices should go to linux-usb@vger.kernel.org

And please, if you do a USB bug report, include "dmesg" and
"lsusb -v"

	HTH
		Oliver



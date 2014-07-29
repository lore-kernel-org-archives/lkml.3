Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaG2J3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:29:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaG2J3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:29:52 -0400
Date: Tue, 29 Jul 2014 11:29:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Duggan <aduggan@synaptics.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH] HID: rmi: only bind the hid-rmi driver to the mouse
 interface of composite USB devices
In-Reply-To: <1405638885-8014-2-git-send-email-aduggan@synaptics.com>
Message-ID: <alpine.LNX.2.00.1407291129440.16390@pobox.suse.cz>
References: <1405638885-8014-1-git-send-email-aduggan@synaptics.com> <1405638885-8014-2-git-send-email-aduggan@synaptics.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Andrew Duggan wrote:

> On composite HID devices there may be multiple HID devices on separate interfaces, but hid-rmi
> should only bind to the mouse interface. One example is the Dell Venue 11 Pro's keyboard dock
> which contains a composite USB device with a HID touchpad and HID keyboard on separate intefaces.
> Since the USB Vendor ID is Synaptic's, hid-core is currently trying to bind hid-rmi to all\of
> the HID devices. This patch ensures that hid-rmi only binds to the mouse interface.
> 
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=80091
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

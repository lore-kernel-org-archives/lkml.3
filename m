Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3IJRAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:00:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48716 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3IJRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:00:22 -0400
Date: Tue, 10 Sep 2013 12:56:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: wlanfae@realtek.com, shwei <shwei@realtek.com.tw>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-wireless@vger.kernel.org,
        Michael Wu <flamingice@sourmilk.net>
Subject: Re: RTL8187SE staging Linux driver
Message-ID: <20130910165606.GB1960@tuxdriver.com>
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:59:54PM +0200, Andrea Merello wrote:
> Hello,
> 
> As you probably know, in the current Linux kernel there is a staging
> driver for the RTL8187SE device (based on my older RTL8180/RTL8185
> Linux driver), while there also a regular (not staging) driver
> supporting older RTL8185 and RTL8180 devices
> (net/wireless/rtl818x/rtl8180) .
> 
> As far as I can see, the RTL8187SE device seems not so much different
> from an RTL8185 device.
> I would like to try (in my spare time) to add support for RTL8187SE
> device in the current RTL818x driver, in order to avoid code
> duplication, remove a driver from staging, and make RTL8187SE using
> mac80211.
> 
> Do any one of you have any comment/objection/suggestions about this ?

I would be extremely happy for you to tackle this.

> Is it possible to get the RTL8187SE documentation to make things easier?

This info used to be readily available.  If you can't find a source, I
probably still have a (mildly useful) datasheet somewhere in my heap...

> For now I will probably keep different RF code for the two cards even
> if the RTL8225 (zebra 2) radio is used by both RTL8187SE and some
> RTL8185 devices, however if I could get enough documentation about it,
> it would be great to try to merge also RF code..
> 
> Thank you,
> Andrea

Seems reasonable...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaJPJTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:19:37 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.143]:60951 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbaJPJTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:19:36 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-11.tower-179.messagelabs.com!1413451173!34027207!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 11:19:33 +0200
Date: Thu, 16 Oct 2014 12:11:03 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141016101102.GA23256@awelinux>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016084412.GB22265@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141016084412.GB22265@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:44:12AM +0200, Greg KH wrote:
> On Thu, Oct 16, 2014 at 10:15:08AM +0200, Andreas Werner wrote:
> > +struct eeprom_data {
> > +	uint8_t eeprod_id;
> 
> Please use the "real" kernel types, "u8" here, and "u32" in other places
> you use uint32_t (those are userspace types, not kernel types, sorry.)
> 

You are right i will change it.

> > +static DEVICE_ATTR(eeprod_id, S_IRUGO, show_eeprod_id, NULL);
> > +static DEVICE_ATTR(revision, S_IRUGO, show_revision, NULL);
> > +static DEVICE_ATTR(serial, S_IRUGO, show_serialnr, NULL);
> > +static DEVICE_ATTR(hw_name, S_IRUGO, show_hw_name, NULL);
> > +static DEVICE_ATTR(prod_date, S_IRUGO, show_prod_date, NULL);
> > +static DEVICE_ATTR(rep_date, S_IRUGO, show_rep_date, NULL);
> 
> DEVICE_ATTR_RO() please.

OK no problem, will change it.

Thanks.

Regards
Andy

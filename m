Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaIBHxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:53:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:57783 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaIBHxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:53:02 -0400
Date: Tue, 2 Sep 2014 11:52:54 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: kavitha bk <bk.kavitha1@gmail.com>
Cc: linux-kernel@vger.kernel.org, andreas.werner@men.de
Subject: Re: eeprom Board Information EEPROM
Message-ID: <20140902095253.GA693@awedesk.fritz.box>
References: <20140829205639.GA584@awedesk.fritz.box>
 <CACx5bVzvJ-x7EdnGX+AraNBwKaxKNwRVvBwN1-0DNY3O155U5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACx5bVzvJ-x7EdnGX+AraNBwKaxKNwRVvBwN1-0DNY3O155U5Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:B0pqiWu6yExfh8V9bXnHOzzGWK5Eu/XZsiHnok8rwlILJbKLrAZ
 u6gXSboOE5QxxjNkaO94ZM/Klg8CjueHbj1Q1ZivRb9c1G1Fwwc64dX7xx0Yo8kwTdpwmIO
 193Ayj25UBIzzX94ECx2tFaHECQ9JoXyvUowjf4CLtqrmOdgSRmcMI6IlA8EI0M87MTxIAm
 IwC0Yw87pOYbUkFUofcoA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 01:52:10PM +0530, kavitha bk wrote:
> On Sat, Aug 30, 2014 at 2:26 AM, Andreas Werner <wernerandy@gmx.de> wrote:
> 
> > I have a question regarding a driver for a Board Information EEPROM.
> >
> > I want to give our customer easy access to our Board Information EEPROM
> > which is an 256byte I2C eeprom.
> >
> 
> 
> >
> > There is a defined structure of information at the beginning of the eeprom
> > which includes board name, serialnumber, production date, repair date and
> > a eeprom structure ident number.
> >
> > The rest of the eeprom is for user defined settings where customer can
> > write
> > any data to.
> >
> > I want to have access to the eeprom without any special to and without
> > installing
> > anything just running linux and to a cat/echo to sysfs entries to
> > read/write
> > data to the eeprom.
> >
> > What i want to do is to create sysfs entries for the pre defined settings
> > and
> > on entrie where customer can access the rest of the eeprom bytes.
> >
> > Is drivers/misc/eeprom the right place to put those kind of driver in?
> 
> 
> Yes You can add here
> 
> > Or are
> > there any other options to write those kind of driver?
> >
> 
> Which eeprom are you using? You can explore CONFIG_EEPROM_AT24 driver for
> writing a sys interface
> 

Ok i will check it out.

Thanks.

Regards
Andy

> 
> >
> >
> > Regards
> > Andy
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

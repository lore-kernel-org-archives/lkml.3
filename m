Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab3EBXgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:36:20 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:10391 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3EBXgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:36:19 -0400
Message-ID: <1367537006.16154.180.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] Driver core: Add offline/online device operations
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Date: Thu, 02 May 2013 17:23:26 -0600
In-Reply-To: <4243991.h6yRePNTyt@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <1647668.odH0HuOGZ9@vostro.rjw.lan>
	 <1367536287.16154.171.camel@misato.fc.hp.com>
	 <4243991.h6yRePNTyt@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 01:36 +0200, Rafael J. Wysocki wrote:
> On Thursday, May 02, 2013 05:11:27 PM Toshi Kani wrote:
> > On Thu, 2013-05-02 at 14:27 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 :
> > >  
> > > +static inline bool device_supports_offline(struct device *dev)
> > 
> > Since we renamed "offline" to "hotplug" for the lock interfaces, should
> > this function be renamed to device_supports_hotplug() as well?
> 
> Well, "offline" is more specific, as there may be devices that don't
> support offline/online, but support hotplug otherwise.  That's why I didn't
> change it.

I see.  That makes sense.

Thanks,
-Toshi


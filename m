Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaAHSYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:24:24 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:6335 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaAHSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:24:22 -0500
Message-ID: <1389205457.1644.13.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
From: Ben Hutchings <bhutchings@solarflare.com>
To: hayeswang <hayeswang@realtek.com>
CC: "=?ISO-8859-1?Q?=27Bj=F8rn?= Mork'" <bjorn@mork.no>, <oliver@neukum.org>,
        <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Date: Wed, 8 Jan 2014 18:24:17 +0000
In-Reply-To: <749DBDC9792E47BBA5884BEC7CF2D639@realtek.com.tw>
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com>
	<1388633110-1435-1-git-send-email-hayeswang@realtek.com>
	<877gai8nqu.fsf@nemi.mork.no>
	<605671F106F540BA9665A195CACB78A0@realtek.com.tw>
	<8738l58pyd.fsf@nemi.mork.no>
	<AA7EB9EA13B74B14BBE08C4278F7948C@realtek.com.tw>
	 <87eh4l31or.fsf@nemi.mork.no>
	 <749DBDC9792E47BBA5884BEC7CF2D639@realtek.com.tw>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20416.005
X-TM-AS-Result: No--21.684600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 20:35 +0800, hayeswang wrote:
>  Bjørn Mork [mailto:bjorn@mork.no] 
> > Sent: Monday, January 06, 2014 5:22 PM
> > To: Hayeswang
> > Cc: oliver@neukum.org; netdev@vger.kernel.org; nic_swsd; 
> > linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> > Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
> [...]
> > Exactly the same device, but now cfg #1 is active and a 
> > different set of
> > drivers have bound to the interfaces.  This is possible 
> > because none of
> > the involved drivers disable the support for this device at 
> > build-time.
> > Instead they use the available interface descriptors for matching and
> > probing supported functions.
> > 
> > End users will of course normally not go around writing stuff to sysfs
> > attributes like this.  Creating an udev rule to select a specific
> > counfiguration when the device is plugged is more useful for normal
> > usage.
> 
> Thanks for your answer. I would study udev rule first.
> Does the udev alwayes exist for all Linux system, such as
> Android, embedded system, and so on?

They may not have udev, but if not they will normally have an alternate
such as mdev.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


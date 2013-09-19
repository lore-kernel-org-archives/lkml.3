Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3ISPxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:53:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42272 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3ISPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:53:05 -0400
Date: Thu, 19 Sep 2013 08:52:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>
Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Message-ID: <20130919155259.GA5731@core.coreip.homeip.net>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com>
 <20130918210107.GA32320@core.coreip.homeip.net>
 <304cbdeb0aa34f9a9ba6b44828fb5647@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304cbdeb0aa34f9a9ba6b44828fb5647@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 11:27:51PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Wednesday, September 18, 2013 2:01 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; dan.carpenter@oracle.com; linux-
> > input@vger.kernel.org; vojtech@suse.cz
> > Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support Hyper-V
> > synthetic keyboard
> > 
> > Hi K.Y.,
> > 
> > On Tue, Sep 17, 2013 at 04:26:58PM -0700, K. Y. Srinivasan wrote:
> > > Add a new driver to support synthetic keyboard. On the next generation
> > > Hyper-V guest firmware, many legacy devices will not be emulated and this
> > > driver will be required.
> > >
> > > I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> > > details of the AT keyboard driver. I would also like to thank
> > > Dan Carpenter <dan.carpenter@oracle.com> and
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> for their detailed review of
> > this
> > > driver.
> > >
> > > I have addressed all the comments of Dan and Dmitry in this version of
> > > the patch
> > 
> > This looks much better. Could you tell me if the patch below (on top of
> > yours) still works?
> > 
> > Thanks.
> 
> Thank you. The code looks much better now. You forgot to initialize the port_data and
> after I fixed that everything seems to work as it did before: Here is the patch I used:

Excellent, thank you for trying it out. I folded it all together and
queued for 3.13.

Thanks.

-- 
Dmitry

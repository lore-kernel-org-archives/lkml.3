Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3J2Epy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:45:54 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:1786
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab3J2Epw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:45:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
Thread-Topic: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
Thread-Index: AQHOxkr73mEL+MoRyUKqi8VAB5hpg5oKfwQAgAADdYCAAAK8AIAAngOwgAABegCAAADz8IAADMgAgAAAF9CAAAFhAIAAAQNg
Date: Tue, 29 Oct 2013 04:45:46 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FE5@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	 <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
	 <1382982462.4097.38.camel@ul30vt.home>
	 <1382983205.3410.6.camel@snotra.buserror.net>
	 <1382983792.3410.13.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4F0B@039-SN2MPN1-013.039d.mgd.msft.net>
	 <1383018042.3410.69.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4F3A@039-SN2MPN1-013.039d.mgd.msft.net>
	 <1383020990.3410.76.camel@snotra.buserror.net>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071D4FA0@039-SN2MPN1-013.039d.mgd.msft.net>
 <1383021306.3410.80.camel@snotra.buserror.net>
In-Reply-To: <1383021306.3410.80.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9T4k1wm009519



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, October 29, 2013 10:05 AM
> To: Bhushan Bharat-R65777
> Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder Stuart-B08248;
> christoffer.dall@linaro.org; linux-kernel@vger.kernel.org;
> a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395;
> peter.maydell@linaro.org; santosh.shukla@linaro.org; kvm@vger.kernel.org;
> gregkh@linuxfoundation.org
> Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
> sysfs only
> 
> On Mon, 2013-10-28 at 23:31 -0500, Bhushan Bharat-R65777 wrote:
> >
> > > -----Original Message-----
> > > From: Wood Scott-B07421
> > > Sent: Tuesday, October 29, 2013 10:00 AM
> > > To: Bhushan Bharat-R65777
> > > Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder
> > > Stuart-B08248; christoffer.dall@linaro.org;
> > > linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> > > agraf@suse.de; Sethi Varun-B16395; peter.maydell@linaro.org;
> > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > gregkh@linuxfoundation.org
> > > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit
> > > binding via sysfs only
> > >
> > > On Mon, 2013-10-28 at 22:52 -0500, Bhushan Bharat-R65777 wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Wood Scott-B07421
> > > > > Sent: Tuesday, October 29, 2013 9:11 AM
> > > > > To: Bhushan Bharat-R65777
> > > > > Cc: Wood Scott-B07421; Alex Williamson; Kim Phillips; Yoder
> > > > > Stuart-B08248; christoffer.dall@linaro.org;
> > > > > linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> > > > > agraf@suse.de; Sethi Varun-B16395; peter.maydell@linaro.org;
> > > > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > > > gregkh@linuxfoundation.org
> > > > > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit
> > > > > binding via sysfs only
> > > > >
> > > > > On Mon, 2013-10-28 at 22:38 -0500, Bhushan Bharat-R65777 wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Wood Scott-B07421
> > > > > > > Sent: Monday, October 28, 2013 11:40 PM
> > > > > > > To: Alex Williamson
> > > > > > > Cc: Kim Phillips; Bhushan Bharat-R65777; Wood Scott-B07421;
> > > > > > > Yoder Stuart-B08248; christoffer.dall@linaro.org;
> > > > > > > linux-kernel@vger.kernel.org;
> > > > > > > a.motakis@virtualopensystems.com; agraf@suse.de; Sethi
> > > > > > > Varun-B16395; peter.maydell@linaro.org;
> > > > > > > santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > > > > > > gregkh@linuxfoundation.org
> > > > > > > Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for
> > > > > > > explicit binding via sysfs only
> > > > > > >
> > > > > > > On Mon, 2013-10-28 at 13:00 -0500, Scott Wood wrote:
> > > > > > > > On Mon, 2013-10-28 at 11:47 -0600, Alex Williamson wrote:
> > > > > > > > > On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> > > > > > > > > > Force the vfio-pci driver to only be bound explicitly
> > > > > > > > > > via sysfs to avoid conflics with other drivers in the
> > > > > > > > > > event of a
> > > hotplug.
> > > > > > > > >
> > > > > > > > > We can't break userspace, so we can't disable the
> > > > > > > > > current method of binding devices to vfio-pci.  We can
> > > > > > > > > add a new method and perhaps deprecate the existing
> > > > > > > > > mechanism to be removed at some point in the future.
> > > > > > > > > Thanks,
> > > > > > > >
> > > > > > > > I thought the existing method involved using sysfs bind,
> > > > > > > > and this was just eliminating a race.  How does the bind
> > > > > > > > get triggered
> > > currently?
> > > > > > >
> > > > > > > OK, so it seems it's relying on the write to new_id calling
> > > driver_attach().
> > > > > > > Sigh.  I guess we could make driver-sysfs-bind-only be
> > > > > > > settable via sysfs, and have new-userspace set both that and
> > > > > > > PCI_ANY_ID (or the specific ID if userspace
> > > > > > > prefers) via new_id.  The platform bus patches could
> > > > > > > continue as is, since there's no existing mechanism to break.
> > > > > >
> > > > > > What about changing the store_new_id() to bypass exact ids
> > > > > > check if driver
> > > > > have PCI_ANY_ID?
> > > > >
> > > > > I don't follow.
> > > >
> > > > store_new_id() function id defined as:
> > > >
> > > > static ssize_t store_new_id(struct device_driver *driver, const
> > > > char *buf, size_t count) {
> > > >         struct pci_driver *pdrv = to_pci_driver(driver);
> > > >         const struct pci_device_id *ids = pdrv->id_table;
> > > >
> > > > <snip>
> > > >         /* Only accept driver_data values that match an existing id_table
> > > >            entry */
> > > >         if (ids) {
> > > >                 retval = -EINVAL;
> > > >                 while (ids->vendor || ids->subvendor || ids->class_mask) {
> > > >                         if (driver_data == ids->driver_data) {
> > > >                                 retval = 0;
> > > >                                 break;
> > > >                         }
> > > >                         ids++;
> > > >                 }
> > > >                 if (retval)     /* No match */
> > > >                         return retval;
> > > >         }
> > > >
> > > >         retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
> > > >                                class, class_mask, driver_data);
> > > > <snip>
> > > >
> > > >
> > > > So when ids == NULL it does not check of vendor etc and calls
> > > > pci_add_dynid()
> > > which in turn calls driver_attach().
> > > >
> > > > If we change the above loop to break if ids->vendor == PCI_ANY_ID
> > > >&& ids- subvendor == PCI_ANY_ID then also we will call pci_add_dyids().
> > >
> > > What problem are you trying to solve?
> >
> > new_id interface to continue working as before.
> 
> In what specific way does this allow new_id to continue working as before?  Be
> verbose.


What I observed that this patch (kim's patch) new_id interface stops working. This is found to be because
store_new_id() checks for pdrv->id_table which is no more NULL, so the below check fails

        if (ids) {
^^
This is no more NULL, so enter inside the loop

                retval = -EINVAL;
                while (ids->vendor || ids->subvendor || ids->class_mask) {
                        if (driver_data == ids->driver_data) {
                                retval = 0;
                                break;
                        }
                        ids++;
                }
                if (retval)   /* No match */
                        return retval;
^^^^^
This is where it returns as -EINVAL
        }

I tried a quick test of what I am saying but it does not work directly (although passes from the above mentioned check), may be some more changes required :(

-Bharat

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3JJICt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:02:49 -0400
Received: from [216.32.181.183] ([216.32.181.183]:14936 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab3JJICh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:02:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I936eI148cI542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de097h186068h8275bh8275dha509lz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>,
        Wood Scott-B07421 <B07421@freescale.com>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Topic: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Index: AQHOvtVzBV4rU1waRU2d31z3B2ehfZngRDQAgAAiCgCAAECXgIAAC74AgADT3ICAADVkAIAAAgwAgAADCQCAAB/ggIAACLGAgAACMICAAAU8gIAAIuWAgAE8pICAAAXnAIAABMAAgAAWmACACVTWgIAABWmAgAAGVwCAAAVEgIAAdf2AgABRUnA=
Date: Thu, 10 Oct 2013 08:01:22 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D071AEED6@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	<20131002184330.GC5108@cbox>	<20131002203735.GA10871@kroah.com>
	<1380748121.12932.89.camel@snotra.buserror.net>
	<20131002211631.GA11914@kroah.com>
	<1380749715.12932.109.camel@snotra.buserror.net>
	<20131002234009.GA27714@kroah.com>
	<1380825207.12932.151.camel@snotra.buserror.net>
	<20131003185434.GA26123@kroah.com>
	<1380827494.12932.161.camel@snotra.buserror.net>
	<20131003203226.GB27336@kroah.com>
	<9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
	<1381346507.7979.334.camel@snotra.buserror.net>
	<9F6FE96B71CF29479FF1CDC8046E15036DDAB4@039-SN1MPN1-002.039d.mgd.msft.net>
	<1381348999.7979.360.camel@snotra.buserror.net>
 <20131009220537.21e36770a44cf43a99a62247@linaro.org>
In-Reply-To: <20131009220537.21e36770a44cf43a99a62247@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of
> Kim Phillips
> Sent: Thursday, October 10, 2013 8:36 AM
> To: Wood Scott-B07421
> Cc: Yoder Stuart-B08248; Wood Scott-B07421; christoffer.dall@linaro.org;
> alex.williamson@redhat.com; linux-kernel@vger.kernel.org;
> a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395; Bhushan
> Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> kvm@vger.kernel.org; gregkh@linuxfoundation.org
> Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
> 
> On Wed, 9 Oct 2013 15:03:19 -0500
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > On Wed, 2013-10-09 at 14:44 -0500, Yoder Stuart-B08248 wrote:
> > > > From: Wood Scott-B07421
> > > > Sent: Wednesday, October 09, 2013 2:22 PM
> > > >
> > > > On Wed, 2013-10-09 at 14:02 -0500, Yoder Stuart-B08248 wrote:
> > > > > Have been thinking about this issue some more.  As Scott
> > > > > mentioned,
> 
> thanks for bringing this up again.
> 
> > > > There's already a "bool suppress_bind_attrs" to prevent sysfs
> > > > bind/unbind.  I suggested a similar flag to mean the oppsosite --
> > > > bind
> > > > *only* through sysfs.  Greg KH was skeptical and wanted to see a
> > > > patch before any further discussion.
> > >
> > > Ah, think I understand now...yes that works as well, and would be
> > > less intrustive.   So are you writing a patch? :)
> >
> > I've been meaning to since the previous round of discussion, but I've
> > been busy.  Would someone else be able to test it in the context of
> > using it for VFIO?
> 
> yes - see below.
> 
> > Otherwise, that looks about right, for the driver side (though
> > driver_attach could error out earlier rather than testing it inside
> > the loop).
> 
> I've made the changes you suggested and tested the resulting diff below on an
> arndale board.  I successfully performed the following sequence of commands
> after first changing the i2c@12C80000 node in the device tree to be exclusively
> compatible with "vfio":
> 
> ===
> # ls -l /sys/bus/platform/drivers/vfio-platform/
> total 0
> --w------- 1 root root 4096 Sep 24 19:17 bind
> --w------- 1 root root 4096 Sep 24 19:13 uevent
> --w------- 1 root root 4096 Sep 24 19:18 unbind # ls -l
> /sys/bus/platform/drivers/s3c-i2c total 0
> lrwxrwxrwx 1 root root    0 Sep 24 19:11 12c60000.i2c ->
> ../../../../devices/12c60000.i2c
> lrwxrwxrwx 1 root root    0 Sep 24 19:11 12c90000.i2c ->
> ../../../../devices/12c90000.i2c
> lrwxrwxrwx 1 root root    0 Sep 24 19:20 12ce0000.i2c ->
> ../../../../devices/12ce0000.i2c
> --w------- 1 root root 4096 Sep 24 19:18 bind
> --w------- 1 root root 4096 Sep 24 19:11 uevent
> --w------- 1 root root 4096 Sep 24 19:17 unbind # ls -l
> /sys/devices/12c80000.i2c/driver  # this is the one with the 'vfio' compatible
> ls: cannot access /sys/devices/12c80000.i2c/driver: No such file or directory #
> ls -l /sys/devices/12ce0000.i2c/driver lrwxrwxrwx 1 root root 0 Sep 24 19:18
> /sys/devices/12ce0000.i2c/driver -> ../../bus/platform/drivers/s3c-i2c
> # echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/unbind
> # ls -l /sys/devices/12ce0000.i2c/driver
> ls: cannot access /sys/devices/12ce0000.i2c/driver: No such file or directory #
> echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind
> # ls -l /sys/devices/12ce0000.i2c/driver lrwxrwxrwx 1 root root 0 Sep 24 19:21
> /sys/devices/12ce0000.i2c/driver -> ../../bus/platform/drivers/vfio-platform
> # echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/unbind
> # ls -l /sys/devices/12ce0000.i2c/driver # echo 12ce0000.i2c >
> /sys/bus/platform/drivers/s3c-i2c/bind
> [  722.137524] s3c-i2c 12ce0000.i2c: slave address 0x38 [  722.141037] s3c-i2c
> 12ce0000.i2c: bus frequency set to 65 KHz [  722.150605] s3c-i2c 12ce0000.i2c:
> i2c-8: S3C I2C adapter # ls -l /sys/devices/12ce0000.i2c/driver lrwxrwxrwx 1
> root root 0 Sep 24 19:21 /sys/devices/12ce0000.i2c/driver ->
> ../../bus/platform/drivers/s3c-i2c
> #
> ====
> 
> so it's correctly not allowing 'vfio' driver to bind to a device tree compatible
> it's declared, and it then can bind the i2c @ 12ce0000 device to the vfio-
> platform driver, and unbind and bind it back to the i2c driver.
> 
> For clarity's sake, before this diff, the command:
> 
> echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind
> 
> would error with:
> 
> echo: write error: No such device
> 
> > The other half of fixing the raciness is to ensure that the device
> > doesn't get bound back to a non-VFIO driver (e.g. due to a module load
> > or new_id).  The solution I proposed for that was a similar
> > explicit-bind-only flag for a device, that the user sets through sysfs
> > prior to unbinding.  This would also be useful in non-VFIO contexts to
> > simply say "I don't want to use this device at all".
> 
> I can take a look at doing this if you're still busy.
> 
> Thanks,
> 
> Kim
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c index 73f6c29..da81442
> 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -201,7 +201,8 @@ static ssize_t bind_store(struct device_driver *drv, const
> char *buf,
>  	int err = -ENODEV;
> 
>  	dev = bus_find_device_by_name(bus, NULL, buf);
> -	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> +	if (dev && dev->driver == NULL && (drv->sysfs_bind_only ||
> +					   driver_match_device(drv, dev))) {

Should not we check 
      if (dev && dev->driver == NULL &&
          (device->explicit_bind_only && drv->explicit_bind_only) ||
          driver_match_device(drv, dev)))


>  		if (dev->parent)	/* Needed for USB */
>  			device_lock(dev->parent);
>  		device_lock(dev);
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c index 35fa368..6f85279 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void
> *data)  {
>  	struct device *dev = data;
> 
> -	if (!driver_match_device(drv, dev))
> +	if (drv->sysfs_bind_only || !driver_match_device(drv, dev))

Likewise .. 

Thanks
-Bharat 

>  		return 0;
> 
>  	return driver_probe_device(drv, dev);
> @@ -476,6 +476,9 @@ static int __driver_attach(struct device *dev, void *data)
>   */
>  int driver_attach(struct device_driver *drv)  {
> +	if (drv->sysfs_bind_only)
> +		return 0;
> +
>  	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);  }
> EXPORT_SYMBOL_GPL(driver_attach); diff --git a/drivers/vfio/vfio_platform.c
> b/drivers/vfio/vfio_platform.c index b92d7bb..ba578b2 100644
> --- a/drivers/vfio/vfio_platform.c
> +++ b/drivers/vfio/vfio_platform.c
> @@ -297,6 +297,7 @@ static struct platform_driver vfio_platform_driver = {
>  		.name	= "vfio-platform",
>  		.owner	= THIS_MODULE,
>  		.of_match_table = vfio_platform_match,
> +		.sysfs_bind_only = true,
>  	},
>  };
> 
> diff --git a/include/linux/device.h b/include/linux/device.h index
> 94638ef..a3ae81e 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -199,6 +199,7 @@ extern struct klist *bus_get_device_klist(struct bus_type
> *bus);
>   * @owner:	The module owner.
>   * @mod_name:	Used for built-in modules.
>   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> + * @sysfs_bind_only: Only allow bind/unbind via sysfs.
>   * @of_match_table: The open firmware table.
>   * @acpi_match_table: The ACPI match table.
>   * @probe:	Called to query the existence of a specific device,
> @@ -232,6 +233,7 @@ struct device_driver {
>  	const char		*mod_name;	/* used for built-in modules */
> 
>  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
> +	bool sysfs_bind_only;		/* only allow bind/unbind via sysfs */
> 
>  	const struct of_device_id	*of_match_table;
>  	const struct acpi_device_id	*acpi_match_table;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html



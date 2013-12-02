Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3LBAHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 19:07:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12592 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LBAHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 19:07:12 -0500
X-AuditID: cbfee690-b7f126d00000418c-20-529bcf2e67cb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>, "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
 <20131128040750.GA29917@kroah.com>
 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
 <1385619863.12210.14.camel@joe-AO722>
 <001d01ceeca3$0557d630$10078290$%han@samsung.com>
In-reply-to: <001d01ceeca3$0557d630$10078290$%han@samsung.com>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
Date: Mon, 02 Dec 2013 09:07:09 +0900
Message-id: <000801ceeef2$71d23160$55769420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7sAn2ARllmo5XuRi6GbbW1T+QMcQAnVVFgAJSJJpA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zI12987ODDJ7P4raYs34Nm8WHtRoW
	S5oyLJoXr2ezuLzwEqvF7PuPWSwu75rDZnF23nE2izOLe9kdOD1mNfSyeSzYVOpxYsZvFo/9
	c9ewe3xZdY3Zo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDIunNvGWHBUuaJ7yW/2BsbrUl2M
	nBwSAiYSVxadYYOwxSQu3FsPZHNxCAksY5T4tXk9O0zRrmNzmSAS0xkltsy7xgLh/GKU2DVv
	JStIFZuAmsSXL4fZQRIiAksZJWbd38cI4jALXGOUuDBzIjNEyy4miX1nl4C1cArYSXz6/wjM
	FhbwkVi8fSoTiM0ioCrxav0JsOW8ArYST5ZshrIFJX5MvscCYjMLaEms33mcCcKWl9i85i3Q
	Ag6gY9UlHv3VBQmLCFhJnDy8DapERGLfi3eMEP/0ckg0bbWHWCUg8W3yIRaIVlmJTQeYIUok
	JQ6uuMEyAegNJItnIVk8C8niWUg2LGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kREuUT
	djDeO2B9iDEZaP1EZinR5HxgksgriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsby/103/8fLvt9eqsN7MvFh5sfVnVYF762KV/RMjP56jv9Z0F8V
	N0VxgYMhqlcb9lp6fJzKtn6igayr87Zz0kzVuXM7/BXVThb+8msICzr/K0ovL2pB4aoH+04c
	SBG8cpZ5beikQ4uvyJ0znVc0kyd+S/np9l23n5joh4fzneles/XkG0az+eZKLMUZiYZazEXF
	iQAUE0zMCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jQV2987ODDB7NY7OYs34Nm8WHtRoW
	S5oyLJoXr2ezuLzwEqvF7PuPWSwu75rDZnF23nE2izOLe9kdOD1mNfSyeSzYVOpxYsZvFo/9
	c9ewe3xZdY3Zo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jFmXDi3jbHgqHJF95Lf7A2M16W6GDk5JARMJHYdm8sEYYtJXLi3nq2LkYtDSGA6o8SWeddY
	IJxfjBK75q1kBaliE1CT+PLlMDtIQkRgKaPErPv7GEEcZoFrjBIXZk5khmjZxSSx7+wSsBZO
	ATuJT/8fgdnCAj4Si7dPBVvIIqAq8Wr9CXYQm1fAVuLJks1QtqDEj8n3WEBsZgEtifU7jzNB
	2PISm9e8BVrAAXSsusSjv7ogYREBK4mTh7dBlYhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCy
	rGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITiLPpHcwrmqwOMQowMGoxMN74cTsICHWxLLi
	ytxDjBIczEoivBZfZwUJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wweWVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6PJsXs8l5Zt/6Igz8EbI9ug/fzP
	slO68Uy7en+GbJhRoGTIfKR8iwbj7qf7f69+nvioMeirYI0p932Z9jKFmQHRtdskQ7afldMJ
	2PnQpOHFpf96NTsyz2hrCnsXXd6z/kLkeWEj2xM/8z5vahSIuPT4SKEYz9dJR82yu5YY3uv9
	f4N/+eMdN0qUWIozEg21mIuKEwF/aSurZgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 10:34 AM, Jingoo Han wrote:
> On Thursday, November 28, 2013 3:24 PM, Joe Perches wrote:
> >On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
> >>On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> >>>On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> >>>>On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> >>>>>On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> >>>>>> This macro is used to create a struct pci_device_id array.
> >>>>>
> >>>>> Yeah, and it's a horrid macro that deserves to be removed, please don't
> >>>>> use it in more places.
> >>>>>
> >>>>> Actually, if you could just remove it, that would be best, sorry, I'm
> >>>>> not going to take these patches.
> >>>>
> >>>> (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> >>>>
> >>>> Hi Joe Perches,
> >>>>
> >>>> Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> >>>> Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> >>>> as below.
> >>>>
> >>>>   WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> >>>>   #331: FILE: drivers/usb/host/ehci-pci.c:331:
> >>>>   +static const struct pci_device_id pci_ids [] = { {
> >>>>
> >>>> However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> >>>> shouldn't be used anymore.
> >>>>
> >>>> So, would you change checkpatch.pl in order to guide to use
> >>>> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> >>>>
> >>>> For example,
> >>>>   WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> >>>
> >>> The documentation doesn't agree with Greg.
> >[]
> >> I say just remove it, I should have done that years ago when I was the
> >> PCI maintainer, just never got around to it.  No other bus has something
> >> like this for their device ids, why should PCI be "special"?
> >
> >Anyone else have an opinion?
> >
> >I don't care one way or another, but please, one way
> >not two.
> 
> (+cc Bjorn Helgaas, linux-pci)
> 
> Then, how about the following steps?
> 
> 1. Fix ./Documentation/PCI/pci.txt as below.
>    (Jingoo Han)
>    The ID table is an array of struct pci_device_id entries ending with an
>    -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
>    -method of declaring the table.  Each entry consists of:
>    +all-zero entry; Each entry consists of:
> 
> 2. Fix ./scripts/checkpatch.pl in order to guide to use
>     struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE.
>     (Joe Perches)

If all DEFINE_PCI_DEVICE_TABLEs are replaced with 'const struct pci_device_id'
and these patches are merged through 'driver-core.git', it will be not
necessary to fix ./scripts/checkpatch.pl.

Then, I will send patches to Greg Kroah-Hartman, with CC'ing each subsystem
maintainer.

Best regards,
Jingoo Han

> 
> 3. Replace DEFINE_PCI_DEVICE_TABLE of ./drivers/*
>     with 'const struct pci_device_id'.
>    (Jingoo Han)
> 
> 4. These patches will be merged through 'driver-core.git'
>     with 'Acked-by' of each subsystem maintainer.
>    (Greg Kroah-Hartman)
> 
> Best regards,
> Jingoo Han
> 
> >Changing checkpatch is a trifle, but there are a _lot_
> >of maintainers to work through if it's to be removed.
> >
> >It'll probably take several releases.
> >
> >$ git grep --name-only -w DEFINE_PCI_DEVICE_TABLE | \
> >  cut -f1,2 -d/ | uniq -c
> >      1 Documentation/PCI
> >      1 arch/x86
> >      1 drivers/bcma
> >      3 drivers/block
> >      1 drivers/char
> >      1 drivers/cpufreq
> >      2 drivers/dma
> >     18 drivers/edac
> >      6 drivers/gpio
> >      6 drivers/gpu
> >      6 drivers/hwmon
> >     20 drivers/i2c
> >      2 drivers/infiniband
> >      1 drivers/ipack
> >      1 drivers/leds
> >      3 drivers/media
> >     10 drivers/mfd
> >      2 drivers/misc
> >      1 drivers/mmc
> >      1 drivers/mtd
> >    132 drivers/net
> >      1 drivers/ntb
> >      1 drivers/pci
> >      5 drivers/pcmcia
> >      2 drivers/platform
> >      1 drivers/ptp
> >      1 drivers/rapidio
> >      7 drivers/scsi
> >      3 drivers/spi
> >     65 drivers/staging
> >      3 drivers/tty
> >      1 drivers/uio
> >      5 drivers/usb
> >      1 drivers/video
> >      1 drivers/virtio
> >      3 drivers/vme
> >      9 drivers/watchdog
> >      1 drivers/xen
> >      1 include/linux
> >      1 scripts/checkpatch.pl
> >      1 scripts/tags.sh
> >      1 sound/oss
> >     67 sound/pci


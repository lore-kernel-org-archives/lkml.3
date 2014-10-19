Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaJSXR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:17:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53257 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751659AbaJSXRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:17:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware node properties
Date: Mon, 20 Oct 2014 01:31:07 +0200
Message-ID: <5096037.ea1oJYRcOC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141019221434.GA7674@kroah.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1628104.Ek1EGbdVha@vostro.rjw.lan> <20141019221434.GA7674@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 20, 2014 06:14:34 AM Greg Kroah-Hartman wrote:
> On Fri, Oct 17, 2014 at 02:14:53PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Add new generic routines are provided for retrieving properties from
> > device description objects in the platform firmware in case there are
> > no struct device objects for them (either those objects have not been
> > created yet or they do not exist at all).
> > 
> > The following functions are provided:
> > 
> > fwnode_property_present()
> > fwnode_property_read_u8()
> > fwnode_property_read_u16()
> > fwnode_property_read_u32()
> > fwnode_property_read_u64()
> > fwnode_property_read_string()
> > fwnode_property_read_u8_array()
> > fwnode_property_read_u16_array()
> > fwnode_property_read_u32_array()
> > fwnode_property_read_u64_array()
> > fwnode_property_read_string_array()
> > 
> > in analogy with the corresponding functions for struct device added
> > previously.  For all of them, the first argument is a pointer to struct
> > fwnode_handle (new type) that allows a device description object
> > (depending on what platform firmware interface is in use) to be
> > obtained.
> > 
> > Add a new macro device_for_each_child_node() for iterating over the
> > children of the device description object associated with a given
> > device and a new function device_get_child_node_count() returning the
> > number of a given device's child nodes.
> > 
> > The interface covers both ACPI and Device Trees.
> > 
> > Suggested-by: Grant Likely <grant.likely@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!


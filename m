Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaJSWPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:15:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaJSWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:15:40 -0400
Date: Mon, 20 Oct 2014 06:14:34 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware
 node properties
Message-ID: <20141019221434.GA7674@kroah.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <11223831.j9KAEfSQsY@vostro.rjw.lan>
 <1628104.Ek1EGbdVha@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628104.Ek1EGbdVha@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 02:14:53PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Add new generic routines are provided for retrieving properties from
> device description objects in the platform firmware in case there are
> no struct device objects for them (either those objects have not been
> created yet or they do not exist at all).
> 
> The following functions are provided:
> 
> fwnode_property_present()
> fwnode_property_read_u8()
> fwnode_property_read_u16()
> fwnode_property_read_u32()
> fwnode_property_read_u64()
> fwnode_property_read_string()
> fwnode_property_read_u8_array()
> fwnode_property_read_u16_array()
> fwnode_property_read_u32_array()
> fwnode_property_read_u64_array()
> fwnode_property_read_string_array()
> 
> in analogy with the corresponding functions for struct device added
> previously.  For all of them, the first argument is a pointer to struct
> fwnode_handle (new type) that allows a device description object
> (depending on what platform firmware interface is in use) to be
> obtained.
> 
> Add a new macro device_for_each_child_node() for iterating over the
> children of the device description object associated with a given
> device and a new function device_get_child_node_count() returning the
> number of a given device's child nodes.
> 
> The interface covers both ACPI and Device Trees.
> 
> Suggested-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

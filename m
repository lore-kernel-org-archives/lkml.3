Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaBUQvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:51:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaBUQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:51:32 -0500
Date: Fri, 21 Feb 2014 08:23:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: balbi@ti.com,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221162316.GA1153@kroah.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <5306F458.9010706@monstr.eu>
 <20140221160442.GA17506@kroah.com>
 <5307790A.4050806@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307790A.4050806@monstr.eu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:04:26PM +0100, Michal Simek wrote:
> On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
> > On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
> >> BTW: u-boot started to use SPDX-License-Identifier
> >> which will be nice to start to use.
> > 
> > I agree, feel free to start sending patches to use this type of
> > identifier for drivers.
> 
> But we probably need to add that Licenses to one location.

No, why would we need to do that?


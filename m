Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3GYEj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:39:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3GYEjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:39:54 -0400
Date: Wed, 24 Jul 2013 21:41:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH 4/5] Intel MIC Card Driver Changes for Virtio Devices.
Message-ID: <20130725044106.GB11906@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
 <ff721c257100467e8f78421ba9055b97e447551e.1374717252.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff721c257100467e8f78421ba9055b97e447551e.1374717252.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 08:31:35PM -0700, Sudeep Dutt wrote:
> +/*
> + * Intel MIC Platform Software Stack (MPSS)
> + *
> + * Copyright(c) 2013 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
> + * USA.
> + *
> + * The full GNU General Public License is included in this distribution in
> + * the file called "COPYING".

Someone needs to tell Intel to take out the address paragraph of thier
"standard template" as it's annoying.  Please remove it, unless you
personally want to keep the file up to date with the address movements
of the FSF for the next 40+ years.

> + * Disclaimer: The codes contained in these modules may be specific to
> + * the Intel Software Development Platform codenamed: Knights Ferry, and
> + * the Intel product codenamed: Knights Corner, and are not backward
> + * compatible with other Intel products. Additionally, Intel will NOT
> + * support the codes or instruction set in future products.

What does this mean?  That's a new one to me...

> +static inline struct device *dev(struct mic_vdev *mvdev)
> +{
> +	return mvdev->vdev.dev.parent;
> +}

Can you pick a worse name?  And you aren't returning the "device", you
are returning the parent, so the name (as short as it is), is wrong.


ick.

greg k-h


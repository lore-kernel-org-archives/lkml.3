Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaKIXFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 18:05:00 -0500
Received: from ozlabs.org ([103.22.144.67]:41654 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaKIXE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 18:04:59 -0500
Message-ID: <1415574297.29291.3.camel@concordia>
Subject: Re: [PATCH v2] hwmon: (ibmpowernv) Use platform 'id_table' to probe
 the device
From: Michael Ellerman <mpe@ellerman.id.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Neelesh Gupta <neelegup@linux.vnet.ibm.com>, jdelvare@suse.de,
        benh@au1.ibm.com, linux-kernel@vger.kernel.org, michaele@au1.ibm.com,
        linuxppc-dev@lists.ozlabs.org, lm-sensors@lm-sensors.org
Date: Mon, 10 Nov 2014 10:04:57 +1100
In-Reply-To: <20141105142149.GA23212@roeck-us.net>
References: <20141105110848.6183.55611.stgit@localhost.localdomain>
	 <20141105142149.GA23212@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 06:21 -0800, Guenter Roeck wrote:
> On Wed, Nov 05, 2014 at 04:45:14PM +0530, Neelesh Gupta wrote:
> > The current driver probe() function assumes the sensor device to be
> > alwary present and gets executed every time if the driver is loaded,
> > but the appropriate hardware could not be present.
> > 
> > So, move the platform device creation as part of platform init code
> > and use the 'id_table' to check if the device present or not.
> > 
> > Signed-off-by: Neelesh Gupta <neelegup@linux.vnet.ibm.com>
> 
> Looks good. We'll need an ack from one of the powerpc maintainers to proceed.

Looks OK to me.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers



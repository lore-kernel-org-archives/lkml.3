Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaCLJZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaCLJZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:25:14 -0400
Date: Wed, 12 Mar 2014 10:25:11 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        clemens@ladisch.de, rob@landley.net, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        andre@andrep.de
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F16 M30h processor
Message-ID: <20140312102511.77faa6ff@endymion.delvare>
In-Reply-To: <531FCF3D.8020409@roeck-us.net>
References: <1394573159-2317-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
	<531FCF3D.8020409@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 20:06:37 -0700, Guenter Roeck wrote:
> On 03/11/2014 02:25 PM, Aravind Gopalakrishnan wrote:
> > Adding new PCI ID to support AMD F16 M30h processor (Mullins).
> > While at it, modify Kconfig and Doc files to reflect the
> > support for newer processors
> >
> > Note: PCI ID for this processor will make it into pci_ids.h
> > as part of this patch:
> > http://marc.info/?l=linux-kernel&m=139291362126057&w=2
> > which should be pulled into 3.15 when merge window opens
> > (It currently sits in 'for-next' branch of bp.git-
> > https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/log/?h=for-next)
> >
> > Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> 
> Looks good. We'll have to see how we can apply this; probably after 3.15-rc1
> comes out. I'll put it into my -staging branch for now and pull in the other
> patch as well to make sure it compiles.

I've updated the wiki accordingly, as well as sensors-detect.

-- 
Jean Delvare
SUSE L3 Support

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaCTE13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaCTE11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:27:27 -0400
Date: Thu, 20 Mar 2014 00:27:00 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        fes@google.com, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Simon Wood <simon@mungewell.org>
Subject: Re: Stricter module param and sysfs permission checks
Message-ID: <20140320042700.GA11505@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Joe Perches <joe@perches.com>, Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	fes@google.com, Bjorn Helgaas <bhelgaas@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Simon Wood <simon@mungewell.org>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
 <1394818720.3253.1.camel@joe-AO722>
 <20140314180258.GA29201@thunk.org>
 <87y509scl3.fsf@rustcorp.com.au>
 <1395032434.2556.10.camel@joe-AO722>
 <1395041214.2556.17.camel@joe-AO722>
 <87zjkmr8w1.fsf@rustcorp.com.au>
 <1395211832.8649.40.camel@joe-AO722>
 <87k3bpr28n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3bpr28n.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 01:43:44PM +1030, Rusty Russell wrote:

 > drivers/mtd/devices/docg3.c:
 >  	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
 > 	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \
 > 
 > drivers/scsi/pm8001/pm8001_ctl.c:
 > static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
 > 	pm8001_show_update_fw, pm8001_store_update_fw);

Why on earth are these world writable ?

	Dave
 

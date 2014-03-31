Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaCaJgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:36:39 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36973 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaCaJgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:36:37 -0400
X-Originating-IP: 50.43.32.211
Date: Mon, 31 Mar 2014 02:36:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-linux-scu <intel-linux-scu@intel.com>,
        "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Message-ID: <20140331093628.GB1202@leaf>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
 <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
 <D9FFE20C522965449E182ACE73889AEB20842693@IRSMSX105.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB20842693@IRSMSX105.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 08:54:49AM +0000, Dorau, Lukasz wrote:
> On Saturday, March 29, 2014 7:04 PM Rashika Kheria <rashika.kheria@gmail.com> wrote:
> > 
> > Mark function as static in isci/phy.c because it is not used outside
> > this file.
> > 
> > This eliminates the following warning in isci/phy.c:
> > drivers/scsi/isci/phy.c:672:6: warning: no previous prototype for
> > ‘scu_link_layer_set_txcomsas_timeout’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

Since you're a maintainer of the driver in question, can you accept the
three patches you acked, or would you suggest that they go through
another tree?

- Josh Triplett

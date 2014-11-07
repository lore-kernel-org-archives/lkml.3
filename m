Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaKGPaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:30:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:10633 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaKGPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413053476"
Message-ID: <1415374224.22887.24.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot time
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Felix Fietkau <nbd@openwrt.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Rodrigo Freire <rfreire@redhat.com>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Herton Krzesinski <hkrzesin@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org
Date: Fri, 07 Nov 2014 17:30:24 +0200
In-Reply-To: <545CE335.8020503@openwrt.org>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com>
		 <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com>
		 <20140909170231.GA14429@logfs.org>
		 <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
		 <20141105202303.GN23619@ld-irv-0074>
	 <1415372340.22887.23.camel@sauron.fi.intel.com>
	 <545CE335.8020503@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 16:20 +0100, Felix Fietkau wrote:
> > The only usage of this driver is emulating a block device on top of NOR
> > flash, and in most cases, only for debugging / research purposes. This
> > is because (a) this driver does not handle bad blocks (and hence,
> > NAND-incompatible) and (b) it does read-erase-write when you modify a
> > block, so it is extremely slow and does not handle power cuts at all.
> I think you got things mixed up a bit. This is not about emulating a
> block device on top of NOR flash. This is about emulating NOR flash on
> top of a regular block device - e.g. USB sticks, SD cards.

Gosh, I'm sorry, you are right. I did mix things up, please, ignore my
e-mail.


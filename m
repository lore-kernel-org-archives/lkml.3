Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaISObj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:31:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:3693 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698AbaISObh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="478695399"
From: "Chew, Kean Ho" <kean.ho.chew@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: RE: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
Thread-Topic: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
Thread-Index: AQHP092crDRkALQTgEOe6wm98ip9IZwHw3eAgAAKMoCAAIbxQP//kXAAgACG10D//3+vgIAAl61g
Date: Fri, 19 Sep 2014 14:31:32 +0000
Message-ID: <1E478852902BF549B22CC4F16C2AE67C0F4724D1@PGSMSX108.gar.corp.intel.com>
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
 <20140919105833.GB31784@xps8300> <541C14E7.8020208@nexus-software.ie>
 <1E478852902BF549B22CC4F16C2AE67C0F472359@PGSMSX108.gar.corp.intel.com>
 <541C295A.6020101@nexus-software.ie>
 <1E478852902BF549B22CC4F16C2AE67C0F47241C@PGSMSX108.gar.corp.intel.com>
 <541C2ED3.7080206@nexus-software.ie>
In-Reply-To: <541C2ED3.7080206@nexus-software.ie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Ho.
> 
> Do you have an idea when ?
> 
> I guess if we're saying the simple patch which works right now - should be
> rejected in favour of alternative code coming - then at a minimum could you
> please give an indication of when that alternative code will be available ?
> 
> Otherwise I think it makes sense to enable the hardware now - using the
> bog-standard means of doing that - just like BYT and others :)

Make sense. I go with Hekki's direction. 

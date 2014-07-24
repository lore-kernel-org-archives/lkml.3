Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbaGXPPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:15:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:37235 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759184AbaGXPPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:15:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,724,1400050800"; 
   d="scan'208";a="548465114"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "eduardo.valentin@gmail.com" <eduardo.valentin@gmail.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] thermal: of: look for sensor driver parent node if
 device node missing
Thread-Topic: [PATCH] thermal: of: look for sensor driver parent node if
 device node missing
Thread-Index: AQHPn1Sn5O7ekVGZ60igMbnc9VG8rpuuhEAAgADgrFA=
Date: Thu, 24 Jul 2014 15:15:00 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301396F53@SHSMSX101.ccr.corp.intel.com>
References: <1405336354-31310-1-git-send-email-ldewangan@nvidia.com>
 <53D0D694.9040101@nvidia.com>
In-Reply-To: <53D0D694.9040101@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Laxman,

As Eduardo is the of thermal author and maintainer, I will take your patch only if you can get ACK from Eduardo.

Eduardo,
Do you have any comments on this?

Thanks,
rui

> -----Original Message-----
> From: Laxman Dewangan [mailto:ldewangan@nvidia.com]
> Sent: Thursday, July 24, 2014 5:49 PM
> To: Zhang, Rui; eduardo.valentin@ti.com
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] thermal: of: look for sensor driver parent node if
> device node missing
> Importance: High
> 
> On Monday 14 July 2014 04:42 PM, Laxman Dewangan wrote:
> > There are some mfd devices which supports junction thermal interrupt
> > like ams,AS3722. The DT binding of these devices are defined as the
> > flat and drivers for sub module of such devices are registered as the
> > mfd_add_devices. In this method, the sub devices registered as
> > platform driver and these do not have the of_node pointer on their
> > device structure. In this case, use the parent of_node pointer to get
> > the required of_node pointer.
> >
> Any comment please?

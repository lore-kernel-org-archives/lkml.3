Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaIXGaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:30:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:64682 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaIXGaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:30:01 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 02:30:00 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="479624046"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mister.freeman@laposte.net" <mister.freeman@laposte.net>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: RE: [PATCH] ata: Disabling the async PM for JMicron chips
Thread-Topic: [PATCH] ata: Disabling the async PM for JMicron chips
Thread-Index: AQHP1zbZCQS1kz5NO0qkTqh4iB96jZwP0FsA
Date: Wed, 24 Sep 2014 06:20:14 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E87CA6@SHSMSX101.ccr.corp.intel.com>
References: <1411450671-2367-1-git-send-email-chuansheng.liu@intel.com>
 <20140923140053.GG14905@mtj.dyndns.org>
In-Reply-To: <20140923140053.GG14905@mtj.dyndns.org>
Accept-Language: zh-CN, en-US
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



> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
> Sent: Tuesday, September 23, 2014 10:01 PM
> To: Liu, Chuansheng
> Cc: rjw@rjwysocki.net; linux-ide@vger.kernel.org;
> linux-kernel@vger.kernel.org; mister.freeman@laposte.net; Zhang, Rui
> Subject: Re: [PATCH] ata: Disabling the async PM for JMicron chips
> 
> On Tue, Sep 23, 2014 at 01:37:51PM +0800, Chuansheng Liu wrote:
> > Be similar with commit (ata: Disabling the async PM for JMicron chip
> 363/361),
> 
> Please use 12_DIGIT_SHA1_PREFIX ("SUBJ") format when referring to
> commits.
> 


> > @@ -1345,10 +1345,10 @@ static int ahci_init_one(struct pci_dev *pdev,
> const struct pci_device_id *ent)
> >  	 * follow the sequence one by one, otherwise one of them can not be
> >  	 * powered on successfully, so here we disable the async suspend
> >  	 * method for these chips.
> > +	 * Jmicron chip 368 has been found has the similar issue, here we can
> > +	 * exclude the Jmicron family directly to avoid other similar issues.
> 
> Let's update the comment as a whole instead of appending to it.
> 

Thanks your comments, Tejun, will send one new patch to review.

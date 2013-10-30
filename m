Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3J3N2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:28:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:20018 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3J3N2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="382239337"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "jack@suse.cz" <jack@suse.cz>,
        "roland@purestorage.com" <roland@purestorage.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH linux-next-20131029] IB/ipath: Fix random stack overflow.
Thread-Topic: [PATCH linux-next-20131029] IB/ipath: Fix random stack
 overflow.
Thread-Index: AQHO1WWP06NoLKIXNESycJ0L01kHYpoNM35Q
Date: Wed, 30 Oct 2013 13:28:15 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211C54FC@FMSMSX107.amr.corp.intel.com>
References: <201310302045.AEH12985.FSOOJOQLHFtMFV@I-love.SAKURA.ne.jp>
In-Reply-To: <201310302045.AEH12985.FSOOJOQLHFtMFV@I-love.SAKURA.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Wed, 30 Oct 2013 16:12:58 +0900
> Subject: [PATCH linux-next-20131029] IB/ipath: Fix random stack overflow.
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: <stable@vger.kernel.org>
> ---

Thanks for catching this!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

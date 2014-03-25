Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaCYXlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:41:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:42617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaCYXlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:41:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,732,1389772800"; 
   d="scan'208";a="507544312"
Subject: Re: [PATCH] Fix late crypto work queue initialization
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
In-Reply-To: <20140321144040.GD25820@gondor.apana.org.au>
References: <1395100347.2970.14.camel@schen9-DESK>
	 <20140321144040.GD25820@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Mar 2014 16:40:56 -0700
Message-ID: <1395790856.2970.33.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 22:40 +0800, Herbert Xu wrote:
> On Mon, Mar 17, 2014 at 04:52:26PM -0700, Tim Chen wrote:
> > The crypto algorithm modules utilizing the crypto daemon could
> > be used early when the system start up.  Using module_init
> > does not guarantee that the daemon's work queue is initialized
> > when the cypto alorithm depending on crypto_wq starts.  It is necessary
> > to initialize the crypto work queue earlier at the subsystem
> > init time to make sure that it is initialized
> > when used.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> Patch applied.

Herbert,

Probably this patch should go to the stable patches as well.
Copying Greg.

Thanks.

Tim


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3EBK2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:28:17 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:28200 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3EBK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:28:16 -0400
Message-ID: <1367490491.5106.137.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [GIT] Networking
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>
CC: <bjorn@mork.no>, <kaber@trash.net>, <torvalds@linux-foundation.org>,
        <hayeswang@realtek.com>, <akpm@linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 2 May 2013 11:28:11 +0100
In-Reply-To: <20130502.051727.949429506738234701.davem@davemloft.net>
References: <20130502.041625.412316202038784117.davem@davemloft.net>
	 <20130502083619.GA22010@macbook.localnet> <87d2t9bvj1.fsf@nemi.mork.no>
	 <20130502.051727.949429506738234701.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19834.005
X-TM-AS-Result: No--24.019600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 05:17 -0400, David Miller wrote:
> From: Bjørn Mork <bjorn@mork.no>
> Date: Thu, 02 May 2013 11:06:42 +0200
> 
> > Adding the new netdev features will make it go from 1 to 2:
> 
> We already had more than 31 feature bits before Patrick's
> changes, and I'm pretty sure this was the case when we added
> that ethtool API.

It wasn't, but this should be OK.  Userland is supposed to query the
number of features using ETHTOOL_GSSET_INFO and then work out the number
of words/blocks using FEATURE_BITS_TO_BLOCKS().  

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


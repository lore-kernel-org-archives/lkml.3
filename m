Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaJGOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:16:28 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41639 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJGOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:16:23 -0400
Date: Mon, 6 Oct 2014 11:00:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: pull request: wireless-next 2014-10-03
Message-ID: <20141006150044.GA25590@tuxdriver.com>
References: <20141003180151.GE27414@tuxdriver.com>
 <20141005.213511.339356320070784471.davem@davemloft.net>
 <20141005.213853.488066614144870837.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005.213853.488066614144870837.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 09:38:53PM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 05 Oct 2014 21:35:11 -0400 (EDT)
> 
> > From: "John W. Linville" <linville@tuxdriver.com>
> > Date: Fri, 3 Oct 2014 14:01:52 -0400
> > 
> >> Please pull tihs batch of updates intended for the 3.18 stream!
> > 
> > Pulled, thanks for the stellar pull request text, as always.
> 
> John, what's the deal with the following?  Will it be resolved by the
> driver being removed from the staging tree?
> 
> WARNING: drivers/staging/rtl8192ee/r8192ee: 'rtl_evm_dbm_jaguar' exported twice. Previous export was in drivers/net/wireless/rtlwifi/rtlwifi.ko

Yes, exactly.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaCYSPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:15:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaCYSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:15:00 -0400
Date: Tue, 25 Mar 2014 11:16:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Subject: Re: [PATCH 3.4] iwlwifi: Complete backport of "iwlwifi: always copy
 first 16 bytes of commands"
Message-ID: <20140325181642.GD3233@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <20140322165145.GA12870@kroah.com>
 <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
 <1553572.xqrhDm938v@tux200s>
 <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
 <1395768502.28354.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395768502.28354.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 05:28:22PM +0000, Ben Hutchings wrote:
> Linux 3.4.83 included an incomplete backport of commit
> 8a964f44e01ad3bbc208c3e80d931ba91b9ea786 ('iwlwifi: always copy first
> 16 bytes of commands') which causes a regression for this driver.
> This is the missing piece.
> 
> Reported-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Jianguo Wu <wujianguo@huawei.com>
> Tested-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks for tracking this down and for the patch, I'll queue it up for
the next 3.4-stable release.

greg k-h

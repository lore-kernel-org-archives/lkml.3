Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaCVQuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:50:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaCVQuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:50:17 -0400
Date: Sat, 22 Mar 2014 09:51:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>
Subject: Re: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of
 commands
Message-ID: <20140322165145.GA12870@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <8891481.xyaW2OauMW@tux200s>
 <20140322162501.GA13385@kroah.com>
 <174441141.AshFyuFNQG@tux200s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174441141.AshFyuFNQG@tux200s>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 05:28:02PM +0100, Andreas Sturmlechner wrote:
> Original Message from: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Does Linus's tree also have this problem for you?  Or does it work
> > there?  If it works there, perhaps we just missed backporting something
> > to 3.4?
> > 
> 
> Other trouble aside, iwlwifi works fine - writing this from today's build of 
> 3.14.0-rc7+.

Hm.  Any linux-wifi developers have an idea?  I can always just revert
this patch, but finding out the root cause would be nice...

greg k-h

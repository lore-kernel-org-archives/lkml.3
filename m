Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaCVQXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:23:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaCVQXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:23:32 -0400
Date: Sat, 22 Mar 2014 09:25:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>
Subject: Re: [PATCH 3.4 93/99] iwlwifi: always copy first 16 bytes of commands
Message-ID: <20140322162501.GA13385@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <20140308010614.545650590@linuxfoundation.org>
 <8891481.xyaW2OauMW@tux200s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8891481.xyaW2OauMW@tux200s>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 03:19:49PM +0100, Andreas Sturmlechner wrote:
> Original Message from: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > commit 8a964f44e01ad3bbc208c3e80d931ba91b9ea786 upstream.
> 
> Forwarding original message to make sure it isn't lost - this patch breaks 
> iwlwifi in >=3.4.83 for at least some people, including me and my Intel(R) 
> Centrino(R) Ultimate-N 6300 AGN, REV=0x74.
> 
> Reverting the patch so far has been a workaround. Before sending, I also tried 
> out 3.4.83 + current stable-queue to make sure the problem persists.

Ok, that's not good.

Does Linus's tree also have this problem for you?  Or does it work
there?  If it works there, perhaps we just missed backporting something
to 3.4?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaCFTwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:52:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFTwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:52:10 -0500
Date: Thu, 6 Mar 2014 11:53:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, bergwolf@gmail.com,
        alexey.zhuravlev@intel.com, josh@joshtriplett.org,
        dulshani.gunawardhana89@gmail.com, jinshan.xiong@intel.com,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH 2/2] lustre/lov_obd: fix possible null pointer dereference
Message-ID: <20140306195356.GB3403@kroah.com>
References: <1394024676-35160-1-git-send-email-maxin.john@enea.com>
 <1394024676-35160-2-git-send-email-maxin.john@enea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394024676-35160-2-git-send-email-maxin.john@enea.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:04:36PM +0100, Maxin B. John wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
> 
> osc_obd can be NULL. cppcheck reported this:
> [lustre/lustre/lov/lov_obd.c:283]: (error) Possible null pointer dereference:
> osc_obd - otherwise it is redundant to check if osc_obd is null at line 295

Same problem, osc_obd can never be NULL, please be more careful with
your patches, and just remove pointless tests instead of papering over
them with patches like this.

thanks.

greg k-h

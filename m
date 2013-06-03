Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3FCOWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:22:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3FCOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:22:14 -0400
Date: Mon, 3 Jun 2013 07:22:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] xilinx systemace: Fix device name assignment for
 SystemACE (from "xs`" to "xsa").
Message-ID: <20130603142242.GB7024@kroah.com>
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
 <51AC9068.7050203@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AC9068.7050203@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:47:36PM +0200, Michal Simek wrote:
> Hi Greg,
> 
> do you want to take these two patches through your tree?

Why would I be sending in drivers/block/* patches?  I don't have a tree
for that, do I?

> Or should I take them through my microblaze tree?

Please do, or send them to the block maintainer.

thanks,

greg k-h

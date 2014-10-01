Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJARkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:40:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaJARj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:39:58 -0400
Date: Wed, 1 Oct 2014 10:39:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chris Kohn <ckohn@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>, Jason Wu <huanyu@xilinx.com>
Subject: Re: [PATCH] staging: Add Xilinx Clocking Wizard driver
Message-ID: <20141001173957.GA32021@kroah.com>
References: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:21:48AM -0700, Soren Brinkmann wrote:
> Add a driver for the Xilinx Clocking Wizard soft IP. The clocking wizard
> provides an AXI interface to dynamically reconfigure the clocking
> resources of Xilinx FPGAs.

Why not just do the few things you have on the TODO list and get it
merged to the "proper" part of the kernel, keeping it out of the staging
tree?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3KSXIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:08:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3KSXIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:08:50 -0500
Date: Tue, 19 Nov 2013 15:09:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.4 01/12] cxgb3: Fix length calculation in
 write_ofld_wr() on 32-bit architectures
Message-ID: <20131119230910.GA13667@kroah.com>
References: <20131118184130.257996039@linuxfoundation.org>
 <20131118184130.528352245@linuxfoundation.org>
 <20131119105000.GA3943@hercules.my.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119105000.GA3943@hercules.my.domain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:50:00AM +0000, Luis Henriques wrote:
> Hi Greg,
> 
> On Mon, Nov 18, 2013 at 10:41:34AM -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> I guess you can drop this commit because, as Ben has already pointed
> out, it is required for kernels >= 3.11.

Good point, now dropped, thanks.

greg k-h

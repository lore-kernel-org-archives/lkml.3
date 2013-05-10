Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab3EJPZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:25:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3EJPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:24:59 -0400
Date: Fri, 10 May 2013 08:24:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, ac100@lists.launchpad.net
Subject: Re: [RFC 25/42] drivers/staging/nvec: don't check resource with
 devm_ioremap_resource
Message-ID: <20130510152458.GF11227@kroah.com>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-26-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368173847-5661-26-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:17:10AM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

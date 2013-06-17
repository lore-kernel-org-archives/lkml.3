Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3FQWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:52:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3FQWwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:52:42 -0400
Date: Mon, 17 Jun 2013 15:52:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, pc@asdf.org,
        oatilla@gmail.com
Subject: Re: [PATCH 01/19] bh1770glc: added input device interface
Message-ID: <20130617225241.GB21613@kroah.com>
References: <cover.1371145891.git.andi@etezian.org>
 <90a9ed312d038eda11648a6ed49bb968824bf875.1371145891.git.andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90a9ed312d038eda11648a6ed49bb968824bf875.1371145891.git.andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 08:20:35PM +0200, Andi Shyti wrote:
> The driver generates an event in /dev/input/ under the name
> 'bh1770'. It's a switch event where is reported '0' or '1'
> whenever the sensor detects something crossing the threshold.
> 
> Signed-off-by: Onur Atilla <oatilla@gmail.com>
> Signed-off-by: Phil Carmody <pc@asdf.org>
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  drivers/misc/bh1770glc.c |   58 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)

Doesn't this mean that this driver is now an "input" driver, so it
shouldn't be using the odd sysfs api, and should move to the
drivers/input/ directory tree?

thanks,

greg k-h

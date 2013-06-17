Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FQWwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:52:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:52:13 -0400
Date: Mon, 17 Jun 2013 15:52:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, pc@asdf.org,
        oatilla@gmail.com
Subject: Re: [PATCH 03/19] bh1770glc: lux0_glass_factor & lux0_comp_factor on
 sysfs
Message-ID: <20130617225212.GA21613@kroah.com>
References: <cover.1371145891.git.andi@etezian.org>
 <0336a23507f74f1dcf7c2f7d08ddf77c7d83df26.1371145891.git.andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0336a23507f74f1dcf7c2f7d08ddf77c7d83df26.1371145891.git.andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 08:20:37PM +0200, Andi Shyti wrote:
> From: Onur Atilla <oatilla@gmail.com>
> 
> Introduced lux0_glass_factor and lux0_comp_factor on sysfs
> 
> lux0_glass_factor and lux0_sensor_comp_factor are provided as
> read-only files on the sysfs structure of the bh1770glc optical sensor.

You can't add/remove/modify sysfs files without the proper
Documentation/ABI changes as well.  Please redo this patch with those
updates.

thanks,

greg k-h

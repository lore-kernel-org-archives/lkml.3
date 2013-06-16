Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3FPVuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:50:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3FPVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:50:33 -0400
Date: Sun, 16 Jun 2013 14:51:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: arnd@arndb.de, rob@landley.net, oatilla@gmail.com, szsolt@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2] etzkx accelerometer support
Message-ID: <20130616215110.GA10834@kroah.com>
References: <cover.1371418586.git.andi@etezian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1371418586.git.andi@etezian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 11:40:26PM +0200, Andi Shyti wrote:
> Hi,
> 
> these two patches provide the etzkx device driver which supports
> the following accelerometers:
> 
>  - Kionix kxcnl
>  - Kionix kxtnk
>  - ST lisn3dsh
> 
> Support for ST lis3dsh accelerometer is still in progress.
> 
> The etzkx accelerometers are a kind of devices that are able to
> do gesture recognition directly on the device. It uses two slots
> of 16 steps (bytes) each for loading algorithms which perform
> gesture recognition.
> 
> The second patch contains the documentation of the device driver.
> 
> On http://www.etezian.org/etzkx/etzkx/ is possible to find more
> informations about the accelerometer.

Why isn't this a drivers/iio/accel/ driver instead of a misc driver?
Please make this an iio driver, then you will be using the correct
user/kernel api to talk to your device.

thanks,

greg k-h

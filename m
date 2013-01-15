Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3AOLg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:36:26 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:61413 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3AOLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:36:25 -0500
Date: Tue, 15 Jan 2013 03:37:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for 3.8-rc4
Message-ID: <20130115113719.GD1748@kroah.com>
References: <50F5067A.2060104@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5067A.2060104@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:34:18PM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> This is the extcon pull request for Linux 3.8-rc4.
> 
> Please pull extcon with following updates:
> 
> Update to max77693/max8997 extcon driver:
> - Using MHL_TA cable for charging.
> - Support JIG cable.
> - Support Dock-Audio device for playing music and button of device.
> - Support Dock-Smart device for desktop mode with mouse/keyboard.
> - Set default UART/USB path on probe().
> - Check the state/type of cable after completing initialization.
> - Code clean to remove duplicate code and bug fix related to sequence of interrupt.
> - Fix irq_flag of max8997/max77693 driver.
> 
> Update to arizona extcon driver:
> - Headphone measurements.
> - Alternative detection mechanism for non-default system designs.
> - Microphone clamp integration.
> - Support for additional detection pin.
> - MICBIAS rise time configuration.
> 
> Thanks in advance for pulling,

This request is for inclusion in 3.9, right?  This seems much too big
for 3.8 at the moment.

greg k-h

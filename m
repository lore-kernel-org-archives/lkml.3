Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3APH1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:27:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:37299 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab3APH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:27:43 -0500
Date: Tue, 15 Jan 2013 23:28:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for v3.9
Message-ID: <20130116072840.GA1089@kroah.com>
References: <50F6437D.50907@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F6437D.50907@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 03:06:53PM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> This is the extcon pull request for v3.9.
> 
> I don't send separate pull request of extcon about bugfixes patch.
> I'd like to apply this patch-set to your next branch for v3.9.
> 
> Please pull extcon with following updates.
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
> Best regards,
> Chanwoo Choi
> 
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
> 
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-for-3.9

Pulled and pushed out, thanks.

greg k-h

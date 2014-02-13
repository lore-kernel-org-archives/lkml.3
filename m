Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBNIZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:25:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50202 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:25:47 -0500
Date: Thu, 13 Feb 2014 13:54:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] Input: synaptics-rmi4 - do not update
 configuration in rmi_f01_probe()
Message-ID: <20140213215432.GA6225@core.coreip.homeip.net>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
 <1392269277-16391-3-git-send-email-dmitry.torokhov@gmail.com>
 <52FD1BC0.1050009@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD1BC0.1050009@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:23:44AM -0800, Christopher Heiny wrote:
> On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> >Do not write configuration data in probe(), we have config() for that.
> 
> Then we should call config() in rmi_function_probe() to ensure that
> any platform data or device tree configuration settings get written
> to the device.

Well, yes, we may elect to update device configuration in probe, but
then we should not be doing that 2nd time in ->config(). We shoudl pick
either one or another.

Thanks.

-- 
Dmitry

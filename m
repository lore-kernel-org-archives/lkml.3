Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaBNIZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:25:47 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55253 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:25:44 -0500
Date: Fri, 14 Feb 2014 00:05:32 -0800
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
Subject: Re: [PATCH 04/11] Input: synaptics-rmi4 - fix LTS handling in F01
Message-ID: <20140214080532.GC14682@core.coreip.homeip.net>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
 <1392269277-16391-4-git-send-email-dmitry.torokhov@gmail.com>
 <52FD1DCE.2040005@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD1DCE.2040005@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:32:30AM -0800, Christopher Heiny wrote:
> On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> >From: Christopher Heiny <cheiny@synaptics.com>
> >
> >Both F01_RMI_Ctrl2 and F01_RMI_Ctrl3 (doze_interval and wakeup_threshold)
> >are controlled by the has_adjustable_doze bit.
> >
> >Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
> >Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Not sure if this need an Ack, but just in case.
> 
> Acked-by: Christopher Heiny <cheiny@synaptics.com>

Not the formal ack but I wanted to make sure I split it off correctly.
Thanks for verifying it!

-- 
Dmitry

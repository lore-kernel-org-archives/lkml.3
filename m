Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaGZBlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 21:41:35 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46172 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaGZBle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 21:41:34 -0400
Date: Fri, 25 Jul 2014 18:41:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series
 2
Message-ID: <20140726014129.GB16900@core.coreip.homeip.net>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Thu, Jul 24, 2014 at 02:13:55PM -0400, Benjamin Tissoires wrote:
> Hi Dmitry,
> 
> this is the second series I told you about for wacom.ko. This series also have
> a good number of removed lines of code. \o/
> 
> The first patch is Jason's one that I finally decided to take with me. His
> previous submission still applied correctly even after the moving of the files
> (git is definitively awesome).
> 
> The second one is a patch I sent earlier and forgot to include in the v2 of
> the first series. It might have been dropped during my many rebases. So here
> he is.
> 
> The rest is for one part enhancing the battery reporting system (to make it
> equal to the one in hid-wacom, and even slightly better). The other part
> is the actual merge of hid-wacom into wacom which gives the same user space API
> for bluetooth and USB devices, fixes the pad-in-a-separate-input-dev, and
> fixes the missing tools not supported in the previous implementation of
> hid-wacom for Intuos 4 BT.
> 

I ended up taking 3.16-rc6 and applying your first series and the first
5 patches of this series to it. You should be able to see the result on
kernel.org in wacom branch.

Thanks.

-- 
Dmitry

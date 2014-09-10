Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaIJSIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:08:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44342 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaIJSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:08:43 -0400
Date: Wed, 10 Sep 2014 11:08:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: serport: Add compat_ioctl routine to support
 32bit inputattach in 64bit systems
Message-ID: <20140910180839.GB38736@core.coreip.homeip.net>
References: <1410240028-9377-1-git-send-email-penmount.touch@gmail.com>
 <20140909181421.GB28774@core.coreip.homeip.net>
 <CAKw_OUUdUA8v=e6=A4EEDpesskbOsZuQrO1Qqm87W6ayurz4Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKw_OUUdUA8v=e6=A4EEDpesskbOsZuQrO1Qqm87W6ayurz4Fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:18:14AM +0800, John Sung wrote:
> Hi Dmitry,
> 
> I tried the patch, and it works with my 32-bit inputattach.

Excellent, I queued it up for mainline.

Thanks.

-- 
Dmitry

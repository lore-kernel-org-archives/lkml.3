Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaCZUUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:20:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57135 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaCZUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:20:33 -0400
Date: Wed, 26 Mar 2014 13:20:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] input: misc: Add driver for Intel Bay Trail GPIO buttons
Message-ID: <20140326202029.GB11013@core.coreip.homeip.net>
References: <533259F7.3050908@linux.intel.com>
 <53325F30.4030006@linux.intel.com>
 <20140326170404.47a6380a@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326170404.47a6380a@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 05:04:04PM +0000, One Thousand Gnomes wrote:
> On Wed, 26 Mar 2014 13:01:36 +0800
> "Zhu, Lejun" <lejun.zhu@linux.intel.com> wrote:
> 
> > This patch adds support for the GPIO buttons on some Intel Bay Trail
> > tablets originally running Windows 8. The ACPI description of these
> > buttons follows "Windows ACPI Design Guide for SoC Platforms".
> 
> I'm not sure calling it "Baytrail" is right here - it's in theory a
> generic interface so probably should be named accordingly
> 
> Otherwise looks good to me.

It uses static devices in non-board code - if I unbind and rebind PNP
device that produces gpio-keys platform devices driver core will not be
happy.

Thanks.

-- 
Dmitry

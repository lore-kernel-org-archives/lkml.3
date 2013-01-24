Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3AXWDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:03:13 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55778 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3AXWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:03:07 -0500
Date: Thu, 24 Jan 2013 14:03:03 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Fengguang Wu <fengguang.wu@intel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: misc: usb3503: add dt support
Message-ID: <20130124220303.GA30869@kroah.com>
References: <1358963242-2596-1-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358963242-2596-1-git-send-email-tobetter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:47:10AM +0900, Dongjin Kim wrote:
> Added device tree support for usb3503 driver and add new document with device tree binding information.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  Documentation/devicetree/bindings/usb/usb3503.txt |   20 +++++++++++++
>  drivers/usb/misc/usb3503.c                        |   31 +++++++++++++++++----
>  2 files changed, 46 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/usb3503.txt

I've applied this, but now we have the compiler warning:
drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
drivers/usb/misc/usb3503.c:215:13: warning: ‘mode’ may be used uninitialized in this function [-Wuninitialized]

Please send a follow-on patch to fix this up.

greg k-h

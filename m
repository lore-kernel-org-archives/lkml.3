Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaKGPMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:12:19 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50944 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaKGPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:12:17 -0500
Date: Fri, 7 Nov 2014 15:12:09 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Capsule update support
Message-ID: <20141107151209.GL3592@console-pimps.org>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
 <20141013095310.GZ14343@console-pimps.org>
 <CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
 <CAGBcZGfSdYa2yXW68RbywzCiC7mTxjAdGjUnwnhjWAwXZ0uqiQ@mail.gmail.com>
 <20141016161507.GJ14343@console-pimps.org>
 <CAGBcZGf5+OkF1QQOJocVHuSKFgC1+rjiNuSBK3Oo3nBfr5RXdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGBcZGf5+OkF1QQOJocVHuSKFgC1+rjiNuSBK3Oo3nBfr5RXdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov, at 03:56:22PM, Sam Protsenko wrote:
> Matt,
> 
> I've tested your patch with zero image size (no image passed, only headers)
> and it crashes because there is no check for image size there.
> This case (zero image size) seems to be legit according to specification
> and also can be useful in real life. So I developed a little fix for your patch:
 
[...]

> I'm planning to use your API for our UpdateCapsule test module so
> it would be really helpful if you can include this fix to your patch.

Sure, I'll include that snippet and post fixed up code next week.

Thanks Sam.

-- 
Matt Fleming, Intel Open Source Technology Center

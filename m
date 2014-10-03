Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaJCMiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:38:18 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58662 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJCMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:38:14 -0400
Date: Fri, 3 Oct 2014 13:38:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        leif.lindholm@linaro.org, roy.franz@linaro.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] efi: rtc-efi: export platform:rtc-efi as module alias
Message-ID: <20141003123810.GI14343@console-pimps.org>
References: <1410423640-1499-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140914135852.GI18582@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914135852.GI18582@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep, at 02:58:52PM, Matt Fleming wrote:
> 
> I haven't picked up any rtc-efi patches before. They appear to have gone
> through akpm in the past.
> 
> Andrew, would you mind picking this one up?

Unless anyone objects, I'm now going to take this through the EFI tree.

-- 
Matt Fleming, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaIHNQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:16:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65331 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHNQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:16:31 -0400
Date: Mon, 8 Sep 2014 14:16:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140908131627.GR3001@console-pimps.org>
References: <20140903175948.GH3001@console-pimps.org>
 <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
 <54084376.8090002@canonical.com>
 <540860F1.6060801@fensystems.co.uk>
 <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
 <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
 <20140904213753.GM3001@console-pimps.org>
 <20140905202744.GO3001@console-pimps.org>
 <CAKv+Gu8GOHMa=zVWBG7OdSG2i2Ag_XyEBE5NzU6ffLNP8zA3Ug@mail.gmail.com>
 <540DA8AB.3060008@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DA8AB.3060008@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep, at 03:01:31PM, Maarten Lankhorst wrote:
> Sorry, forgot about it.
> 
> My system boots fine with this patch, thanks!

Excellent, thanks for testing. I'll queue this up in the 'urgent'
branch.

-- 
Matt Fleming, Intel Open Source Technology Center

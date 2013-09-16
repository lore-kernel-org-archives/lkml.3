Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3IPKTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:19:36 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56154 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3IPKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:19:35 -0400
Date: Mon, 16 Sep 2013 11:19:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Denis CIOCCA <denis.ciocca@st.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct
 group
Message-ID: <20130916101925.GJ3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
 <5234A20F.7040008@kernel.org>
 <20130916080546.GC3999@lee--X1>
 <5236CD17.5010901@st.com>
 <20130916093812.GG3999@lee--X1>
 <5236D5F0.2030601@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5236D5F0.2030601@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's what the datasheet for the board says. Perhaps it's that that's 
> > incorrect? Annoyingly, instead of printing the device name on the 
> > package, ST put some non-Googleable nonsense is there instead 
> > (probably the serial number). Nevertheless, I'll revert the patch and 
> > work something else out.
> 
> I've tried with real device...Unfortunately, you are right for name on 
> the package...
> So, are you using the LSM303DLHC?

According to my datasheet [1], I have the LSM303DLH.

[1] http://www.calao-systems.com/repository/pub/EMBEDDED%20COMPUTERS/SKY-S9500-ULP-XXX/C12-SDK/SCH-00103-B11.pdf

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

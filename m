Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbaKTQxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:53:23 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:57252 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaKTQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:53:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v3 0/2] arm64: Add support for Juno development board
Date: Thu, 20 Nov 2014 17:52:47 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
References: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201411201752.47955.arnd@arndb.de>
X-Provags-ID: V02:K0:/xGdCYTpDZBwz4CW8l/9TyGD1mohODB2p9K9oU+WYbf
 JX5ubH/W4iSpUOhg+9I15Kxcv7Gd3UHKgPECyDHFB1HlsE98rI
 lmIlcl6Sb+3ZSDJKEUzl4AvJrZKoR1fLMW8lJckYl/tdNr3AB5
 SJX7KQ842sH7u468GXRpHISix1cYFSy72/2eadv01tj+85hwYZ
 nPXL5I0Et8KaqrdmtHWGLoyWVhVuUbQ6iWEUZhiigyND+HGbGr
 rMfU7uY2DV9NHZ+PHsMe+hhKxIggVxxuOH+uPBqQJOjItOPNHm
 VUiyAHmzi5idBC/cC9nRIjfQHq1MgUmxr0tR5lcu5V8OIcwmtv
 I/fkWRWgNzltR6hzZnmBKyixolz/gO+iJv+FO2VV/
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 November 2014, Liviu Dudau wrote:
> Hi,
> 
> This patchset adds device tree support for ARM's AArch64 Juno development
> board. It enables use of various peripherals on the board, from USB and
> networking to I2C and PL011 UART.
> 
> The patches can also be found in the repository at:
> 
>    git://github.com/ARM-software/linux.git juno/dts-for-armsoc

Applied both on the arm64 tree, on top of the directory cleanup branch.

Thanks,

	Arnd

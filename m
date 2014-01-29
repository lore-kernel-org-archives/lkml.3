Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaA2PIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:08:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaA2PIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:08:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marc C <marc.ceeeee@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        Feng Kan <fkan@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 5/5] Documentation: power: reset: Add documentation for generic SYSCON reboot driver
Date: Wed, 29 Jan 2014 16:08:47 +0100
Message-ID: <3683633.QqePEXQehq@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52E2F450.2070100@gmail.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com> <20140124182355.GF4758@e106331-lin.cambridge.arm.com> <52E2F450.2070100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e29CGldMTt6nTP6fjH80hIj/33myxa66unONhBnqJgy
 XFosJz5buahMALuTeXxDnpEuHXbfg0QuauhhZs6w/emmj1/uV9
 j2zj5r8RYHSke3SELXOMpneaai+ZdLQXpHZy+plq1VT6dvay4g
 Kb83HmOU7iCYpBFwHu2SKBBI+1aTzlnE+nkHJS0OZuMK5+56np
 FuKoRfOiy5enQxr6d+V5fv2Io61FeNcwiTWusDdbxEeZpph8MY
 XRiagDC242zA/tF/bdAF0Bf5K/lsbUeSwZRnSp9a+1GWhv7vdn
 rBr6k/CnukR8tGsWTgqXG+U5Xg4IkDPur6YQSSPdviIwaP8d+c
 xXj5YTAstosN3Af0Hu9U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 15:16:32 Marc C wrote:
> 
> > What's wrong with having a system clock unit binding, that the kernel
> > can decompose as appropriate?
> 
> From what I understand, the arm-soc maintainers want to reduce (and perhaps even
> eliminate) these board-specific constructs, and try to utilize common driver-code that
> resides in the "driver" folder. I can vouch for the syscon/regmap framework as something
> which would enable the effort.

While your statement is true in general, it doesn't seem to counter
what Mark R said above.

	Arnd

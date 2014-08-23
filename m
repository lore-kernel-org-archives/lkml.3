Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHWOtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:49:55 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:41245 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHWOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <201408231556.42571.arnd@arndb.de>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
 <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com>
 <20140823063113.GC23715@localhost> <201408231556.42571.arnd@arndb.de>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sat, 23 Aug 2014 16:48:52 +0200
Message-ID: <CAOiHx=noe=614vv4GyhuvfoAYj0jYDhO5vX+7M2RbQBpE-uPnQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Andrew Bresticker <abrestic@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 3:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Another argument is that we plan to actually move all the dts files out of
> the kernel into a separate project in the future. We really don't want to
> have the churn of moving all the files now when they get deleted in one
> of the next merge windows.
>
> I don't know if we talked about whether that move should be done for
> all architectures at the same time. If that is the plan, I think it
> would be best to not move the MIPS files at all but also wait until
> they can get removed from the kernel tree.

I wonder how this is supposed to work with dtbs that are currently
expected to be built into the kernel?


Jonas

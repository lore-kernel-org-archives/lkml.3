Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaH3Hx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 03:53:57 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61310 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH3Hxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 03:53:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
Date: Sat, 30 Aug 2014 09:53:26 +0200
Message-ID: <6798670.9zbxUzsGyC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409350479-19108-4-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-4-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jVNMh6xihCgzQkoD4epNPg7b+gFqsQhkoV0GrU1QY14
 PQobtHfmAr3Plcn1zOSQNPQnD52EqUIa7MEhfUzli35VB/bOde
 eB4jfa4EBL+8Fo2ohcZvB2XwGNah50l1vW7hwjlrf4nUOfReXE
 07LG4SjKyFRMb0VH+1SkL9YrXG41LNoTwGVOeWjrL8oGCnx5ca
 zq4pBESDQC+eJhy+LUncqUrbtm7X0x4stESFMgB1fIl5WsDwEJ
 wUO9ishDX0o4denHRRe1+YwJrykl/lu18SQIpxHzegmmC394aQ
 sZoON7E1y/AUQeS5RmHObUsAotWAqZdiHljcJ6qTefraoM5Azb
 a8tam8PBjBFKqrpMweYo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2014 15:14:30 Andrew Bresticker wrote:
> The Global Interrupt Controller (GIC) present on certain MIPS systems
> can be used to route external interrupts to individual VPEs and CPU
> interrupt vectors.  It also supports a timer and software-generated
> interrupts.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
> 

This may be a stupid question, but is this related to the ARM GIC
in any way or does it just share the name?

In either case the binding belongs into
Documentation/devicetree/bindings/interrupt-controller/.

The ARM one should be moved there as well, and then we have
to come up with a new name for the files when there is a conflict.


	Arnd

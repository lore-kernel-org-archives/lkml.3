Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaANSnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:43:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:43:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot dts node.
Date: Tue, 14 Jan 2014 19:42:37 +0100
Message-ID: <12661649.81PZ6nxnIe@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAL85gmD+34VKSHsGXWTbQ2w3razo_cKukfe=dSQJi+x-Zfvtpw@mail.gmail.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <201401140706.13406.arnd@arndb.de> <CAL85gmD+34VKSHsGXWTbQ2w3razo_cKukfe=dSQJi+x-Zfvtpw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KC42ho7/Q1UxaWXigOEabVNhdlZkjem5Sez3YW4ukAa
 BDPomCUSeclpCGfPq5+lQXsQuswR+dlMdfR4rerjPIZIeo7Xap
 0Lz3TUlgvCblFgqYejPKZdDLguRnymigfTQ4ItIfGFHLCb0wKU
 3z3DqxA8kZosQ+yso2nocw2DRzXmCLVjws/45AHRMcGxdIFjXI
 7EvDdkAWg7wA/S3TP0mt3BR2FYogmlocjrorcXxOrewJ50aO6C
 Bwo/15hVDVbcuYLBBwQnzILpZqy6WqRB+1a8cqimM82QSsFFQr
 k3LceIqrGwB3JVfIjW7DoQNPdY1rULYuE9l+1CVS9+jZlFQ921
 fXjSoXPlXnS4J2iKeoAQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014 10:35:33 Feng Kan wrote:
> On Mon, Jan 13, 2014 at 10:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 14 January 2014, Feng Kan wrote:
> >>
> >> >
> >> > Is this related to the standard ARM SCU that manages multiprocessor
> >> > systems, or a different unit that uses the same name?
> >>
> >> FKAN: You mean the snoop control unit in ARM. This is different from
> >> that, the main function of this unit is clk control.
> >
> > Hmm, if it's *mainly* used for clocks, you may actually just want to
> > have a driver in drivers/clk for it that also performs a few of the
> > other things on the side.
> >
> 
> FKAN: there among other thing, reset controls, fuse id's and deep sleep
> resume registers... I like your idea of using syscon, we can have a node
> for SCU and then the specific driver to parse out the needed chunk to use.

Yes, sounds good.

	Arnd

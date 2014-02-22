Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBVWck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:32:40 -0500
Received: from mout.gmx.net ([212.227.15.19]:57814 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaBVWci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:32:38 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: rfkill: gpio: remove unused and obsoleteplatform parameters
Date: Sat, 22 Feb 2014 23:32:04 +0100
Message-ID: <2556368.zbgmUK7WzX@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.11.0-15-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20140221142349.GB10489@xps8300>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com> <1723302.jKkc8NDNRI@fb07-iapwap2> <20140221142349.GB10489@xps8300>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:u+aDqJNYRjENl9zH6JJ8gUvPF/5MUtGIo3IY4BdLYxZWdcGEje9
 do0Yjp0fvtQRzUhcmSn9QuqD5Z+dfbtljsKfqY8SXDlj3M9Ra6sXDc76au/PHn4j5C+CWUf
 puoZi+miLyGxHudRz0C6++FBAyayNzP9h/JDY9XDtNdbFBNjGosbOfZKHePwPDmQLpjDbKJ
 TQYZT1uxySDnJftq72Adg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 16:23:49 Heikki Krogerus wrote:
> Hi,
> 
> On Fri, Feb 21, 2014 at 02:55:14PM +0100, Marc Dietrich wrote:
> > Am Donnerstag, 20. Februar 2014, 14:51:34 schrieb Heikki Krogerus:
> > > After upgrading to descriptor based gpios, the gpio numbers
> > > are not used anymore. The power_clk_name and the platform
> > > specific setup and close hooks are not used by anybody, and
> > > we should not encourage use of such things, so removing them.
> > 
> > arch/arm/mach-tegra/board-paz00.c is still using platform data. Is there
> > some prerequisite patch I'm missing (3.14-rc3) or how can this file be
> > converted? We are waiting for DT support to arrive so we can finally
> > remove this file.
> True! It still set's the shutdown_gpio and reset_gpio members. I think
> I'll leave the header untouched and just clean net/rfkill/rfkill-gpio.c
> in this patch. We can remove the whole header after you guys have moved
> to DT.

Why? Just update the board file to remove those entries. I just checked that 
it's working fine without. So if you don't mind, add a patch to remove the 
entries as the first patch in your series.

Thanks

Marc

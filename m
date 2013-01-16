Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3APDsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:48:52 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:50494 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab3APDsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:48:51 -0500
Message-ID: <1358308153.32106.8.camel@gitbox>
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc tree
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 16 Jan 2013 16:49:13 +1300
In-Reply-To: <20130116141411.8fadedee54ed35dc0eddd288@canb.auug.org.au>
References: <20130116141411.8fadedee54ed35dc0eddd288@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 14:14 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tegra tree got a conflict in
> drivers/clocksource/Makefile between commit ff7ec345f0ec ("timer: vt8500:
> Move timer code to drivers/clocksource") from the arm-soc tree and commit
> ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
> the tegra tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

I don't know about everyone else, but I feel the preference should be to
keep things alphabetized where possible to help avoid with merge
conflicts later on. This is always a problem when we start tacking
things on the end of lists.

I realise this Kconfig is not alphabetized anyway, but it's never too
early to start on the 'right' path.

Regards
Tony P


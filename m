Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3H0Paj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:30:39 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45097 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3H0Pag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:30:36 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
References: <20130827183313.aa7d51c6dd0b21cd8168aa35@canb.auug.org.au>
Date: Tue, 27 Aug 2013 08:30:32 -0700
In-Reply-To: <20130827183313.aa7d51c6dd0b21cd8168aa35@canb.auug.org.au>
	(Stephen Rothwell's message of "Tue, 27 Aug 2013 18:33:13 +1000")
Message-ID: <87wqn7w3qf.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-mvebu/platsmp.c between commit f6cec7cd0777 ("ARM: mvebu:
> remove device tree parsing for cpu nodes") from the  tree and commit
> 994c8c94b419 ("ARM: mvebu: Remove the harcoded BootROM window
> allocation") from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fix looks correct, thanks.

Kevin (for arm-soc folks)

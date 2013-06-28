Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3F1AIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:08:45 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44909 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3F1AIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:08:44 -0400
Date: Thu, 27 Jun 2013 17:08:53 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Remove ARM local timer API
Message-ID: <20130628000853.GB11547@quad.lixom.net>
References: <20130625200211.GA11625@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625200211.GA11625@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 01:02:12PM -0700, Stephen Boyd wrote:
> Olof/Arnd,
> 
> These patches remove the ARM local timer API. The ARM architected
> timers have already moved away from this API so this series
> migrates the rest of the users allowing us to remove the API
> entirely. Thomas has been kind enough to take the first two
> patches into timers/core in the tip tree (thanks Thomas!) so I've
> merged that into v3.10-rc1 and then applied the rest of the
> patches on top. Let me know if this is acceptable.

We need guarantees from Thomas that the branch is stable and will never be
rebased before it hit Linus tree, or we'll be in a world of pain for
dependencies like these.

Thomas, is this branch stable or do you anticipate a rebase?


-Olof

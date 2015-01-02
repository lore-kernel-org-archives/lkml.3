Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbbABSuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:50:04 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62091 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbABSuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:50:02 -0500
Date: Fri, 2 Jan 2015 19:49:56 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Amir Vadai <amirv@mellanox.com>, Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net-next 00/11] Time Counter fixes and improvements
Message-ID: <20150102184956.GA4206@localhost.localdomain>
References: <cover.1418504883.git.richardcochran@gmail.com>
 <CALAqxLUVU3XmBMiNGH-X5KjGbEjDYtaR2WRXDOHfGNads9caOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUVU3XmBMiNGH-X5KjGbEjDYtaR2WRXDOHfGNads9caOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 10:37:09AM -0800, John Stultz wrote:
> Though, this does start to sound like issues the timekeeping code had
> to resolve, so while its probably time to let some flowers bloom and
> see what happens, we should be somewhat watchful for too much logic
> duplication.

You took the words right out of my mouth.

My feeling is that this timecounter code might become more
complicated, and if the core time keeping becomes more
straightforward, then maybe one day the two will join.

Thanks,
Richard

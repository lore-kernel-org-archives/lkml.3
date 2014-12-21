Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaLUTB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:01:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46046 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaLUTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:01:55 -0500
Date: Sun, 21 Dec 2014 20:01:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amir Vadai <amirv@mellanox.com>,
        Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net-next 04/11] net: bnx2x: convert to timecounter
 adjtime.
Message-ID: <20141221190149.GA5676@localhost.localdomain>
References: <cover.1418504883.git.richardcochran@gmail.com>
 <976abf89c833c376c2666def2c60a7de0f020026.1418504889.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976abf89c833c376c2666def2c60a7de0f020026.1418504889.git.richardcochran@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 07:46:59PM +0100, Richard Cochran wrote:
> This patch changes the driver to use the new and improved method
> for adjusting the offset of a timecounter.

BTW, I noticed that this driver does not serialize access to the
timecounter in any way, but probably it should. Ariel?

Thanks,
Richard

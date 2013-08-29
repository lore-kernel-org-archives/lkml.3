Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3H2HIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:08:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46961 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3H2HIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:08:47 -0400
Date: Thu, 29 Aug 2013 16:08:27 +0900
From: takashi.yoshii.zj@renesas.com
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, arnd@arndb.de,
        magnus.damm@gmail.com
Subject: Re: [PATCH] arm: Prevent memory aliasing on non-LPAE kernels
Message-Id: <20130829160827.5c13ad5af24a4d85c4df2eef@renesas.com>
In-Reply-To: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
References: <1369950320-22784-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stepan,
What is the status of this fix?

I am looking forward it to be merged, but it seems not have happend, yet.
Are you waiting for it to be merged, too? or planning to post v2?
# IMHO, v2 is not needed. Checked conditions and places are reasonable.

I just confirmed on 3.11-rc7, that
- The issue still exists.
- This patch can be applied cleanly, and fixes the issue.

Thanks,
/yoshii

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaABSdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:33:07 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50781 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaABSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:33:05 -0500
Date: Thu, 2 Jan 2014 10:31:00 -0800
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] MSM patches for 3.14
Message-ID: <20140102183100.GA8684@quad.lixom.net>
References: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 11:09:13AM -0800, David Brown wrote:
> The following series contains a warning fix, a bit of cleanup, adds a
> few more boards.  There are still numerous patches floating with
> issues, but things seem to be moving in the right direction.
> 
> These have all been sent previously to the lists, and received reviews
> and necessary acks.
> 

Hi,

I've applied these across the various branches, i.e I split the series up
into fixes, soc, dt and board changes.

I chose to split the Dragonboard patch up into two patches instead of one:
One that adds SoC support, and a second that adds the board support. I
rephrased commit messages accordingly but the contents was untouched
(just split up).

I hope the clock stuff can be sorted out real quick so we get working support
for more useful IP on the SoC in time for 3.14.


-Olof

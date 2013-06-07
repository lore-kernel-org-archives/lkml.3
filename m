Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3FGGx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:53:56 -0400
Received: from s72.web-hosting.com ([198.187.29.21]:58682 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3FGGxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:53:54 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 02:53:54 EDT
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20913.31693.629856.620724@gargle.gargle.HOWL>
Date: Fri, 7 Jun 2013 11:51:01 +0530
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Sujith Manoharan" <c_manoha@qca.qualcomm.com>
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 wireless tree
In-Reply-To: <20130607125612.4016cd4ee44614642dc5dd31@canb.auug.org.au>
References: <20130607125612.4016cd4ee44614642dc5dd31@canb.auug.org.au>
X-Mailer: VM 8.2.0b under 24.3.50.1 (x86_64-unknown-linux-gnu)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server72.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - msujith.org
X-Get-Message-Sender-Via: server72.web-hosting.com: authenticated_id: sujith@msujith.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/ath/ath9k/Kconfig between commit 8bb7f167a12a
> ("ath9k: Use minstrel rate control by default") from the wireless tree
> and commit cf657a2bc50d ("ath9k: Remove MAC_DEBUG") from the
> wireless-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks !

Sujith

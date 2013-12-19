Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3LSLtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:49:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6063 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3LSLs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:48:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384300800"; 
   d="scan'208";a="86107340"
Date: Thu, 19 Dec 2013 11:48:58 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH v3 8/8] drivers: net: Mark function
 xenvif_count_frag_slots() as static in netback.c
Message-ID: <20131219114857.GI25969@zion.uk.xensource.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
 <72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72d6fe114ba7cc2f09f51e279313860f83142d46.1387382457.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:26:47PM +0530, Rashika Kheria wrote:
> This patch marks the function xenvif_count_frag_slots() in netback.c as
> static because they are not used outside this file.
> 
> Thus, it also removes the following warning in xen-netback/netback.c:
> drivers/net/xen-netback/netback.c:218:14: warning: no previous prototype for ‘xenvif_count_frag_slots’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Easy, there's no need to resend the patch with maintainer's Acked-by.
DaveM will take care of this. Just be patient. :-)

Wei.

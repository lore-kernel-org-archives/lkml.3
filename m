Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3HTIai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:30:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36122 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3HTIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:30:37 -0400
Date: Tue, 20 Aug 2013 11:30:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Leon Ma <xindong.ma@intel.com>
Cc: gregkh@linuxfoundation.org, ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LMK: Optimize lowmem_shrink
Message-ID: <20130820083024.GJ22811@mwanda>
References: <1376961393.20932.8.camel@leonma-sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376961393.20932.8.camel@leonma-sh>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 09:16:33AM +0800, Leon Ma wrote:
> From: Leon Ma <xindong.ma@intel.com>
> Date: Mon, 19 Aug 2013 14:22:38 +0800
> Subject: [PATCH] LMK: Optimize lowmem_shrink.
> 
> By comparing with selected_oom_score_adj instead of min_score_adj,
> we may do less calculation.
> 

The patch is line wrapped and doesn't apply.
Read Documentation/email-clients.txt.  Send it to yourself first.
Save the whole email as raw text (including headers and everything).
cat email.txt | git am.
When that works, then resend.

regards,
dan carpenter


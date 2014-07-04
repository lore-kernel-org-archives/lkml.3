Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaGDOIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:08:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbaGDOIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:08:11 -0400
Date: Fri, 4 Jul 2014 16:08:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: m.chehab@samsung.com, tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        dougthompson@xmission.com, mitake@dcl.info.waseda.ac.jp,
        aris@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] x38_edac: make use of lo_hi_readq()
Message-ID: <20140704140800.GB3340@pd.tnic>
References: <cover.1403818526.git.jbaron@akamai.com>
 <bb9a4cbb980cc7b51be75cbfcf644553bf6a04cd.1403818526.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bb9a4cbb980cc7b51be75cbfcf644553bf6a04cd.1403818526.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:58:32PM +0000, Jason Baron wrote:
> Convert to the generic API.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

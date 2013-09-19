Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3ISJML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:12:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33864 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab3ISJMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:12:09 -0400
Date: Thu, 19 Sep 2013 11:12:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, davej@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, AMD64_EDAC: Remove superfluous condition check.
Message-ID: <20130919091204.GA9412@pd.tnic>
References: <1378914958-2289-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1378914958-2289-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:55:58AM -0500, Aravind Gopalakrishnan wrote:
> The condition check 'channel < 0' is needless since channel is unsigned.
> 
> Reported by Dave Jones here:
> http://marc.info/?l=linux-kernel&m=137839225430844&w=2
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

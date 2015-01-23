Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbbAWJ6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:58:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41816 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbbAWJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:58:43 -0500
Date: Fri, 23 Jan 2015 10:58:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: x86/MCE: drop bogus const modifier from AMD's bank4_names()
Message-ID: <20150123095838.GA22635@pd.tnic>
References: <54C21511020000780005890E@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C21511020000780005890E@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 08:32:01AM +0000, Jan Beulich wrote:
> The compiler validly warns about it being ignored.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Applied, thanks.

Out of curiosity: When do you see this? Building with
-Wignored-qualifiers or -Wextra?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--

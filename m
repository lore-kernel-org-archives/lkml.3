Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbbAWKQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:16:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60906 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbbAWKQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:16:28 -0500
Date: Fri, 23 Jan 2015 11:16:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: x86/MCE: drop bogus const modifier from AMD's bank4_names()
Message-ID: <20150123101623.GB22635@pd.tnic>
References: <54C21511020000780005890E@mail.emea.novell.com>
 <20150123095838.GA22635@pd.tnic>
 <54C22B040200007800058A07@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C22B040200007800058A07@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:05:40AM +0000, Jan Beulich wrote:
> It's been a long while ago that I noticed and fixed the warning, so
> I don't recall the details. What I do know is that I didn't force any
> extra flags, and that a similar issue elsewhere in the tree (fixed
> in 3.19-rc5) triggered the same warning in at least one of my builds
> (again without any extra warning options) in -rc4.

Older compiler maybe. Not that it is worth wasting too much time on it
though...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--

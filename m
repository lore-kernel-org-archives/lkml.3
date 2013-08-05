Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3HENCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:02:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40468 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab3HENCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:02:45 -0400
Date: Mon, 5 Aug 2013 14:02:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] urgent fix
Message-ID: <20130805130242.GU2515@console-pimps.org>
References: <20130729080836.GD2515@console-pimps.org>
 <20130730185212.GA21687@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730185212.GA21687@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul, at 08:52:12PM, Ingo Molnar wrote:
> Pulled into tip:x86/urgent, thanks Matt!

Thanks Ingo.

Any chance we can get this to Linus for -rc5? The ARM EFI boot stub
patches depend on the bug fix in this pull request.

-- 
Matt Fleming, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3GORQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:16:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55115 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751383Ab3GORQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:16:30 -0400
Message-ID: <1373908589.2062.18.camel@joe-AO722>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
From: Joe Perches <joe@perches.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Date: Mon, 15 Jul 2013 10:16:29 -0700
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 22:27 +0800, Peng Tao wrote:
> Hi Greg,
> 
> Now that 3.11-rc1 is out, please consider queuing following patches to
> fix various Lustre client build issues. I've verified that we can now
> pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.

These patches apply to linus' current, but not to -next
where other lustre patches have already been applied.

What's the goal here?  Are you going to ask for the
patches in -next to be reverted or are you going to
respin these patches for -next instead?


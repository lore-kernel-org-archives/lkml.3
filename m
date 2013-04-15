Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab3DOEBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:01:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36496 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3DOEBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:01:42 -0400
Date: Sun, 14 Apr 2013 21:01:44 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] msm cleanup for 3.10
Message-ID: <20130415040144.GE10949@quad.lixom.net>
References: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ya7gk7qsnp.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 03:40:42PM -0700, David Brown wrote:
> The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:
> 
>   Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-cleanup-3.10

Hi,

I've pulled in all 4 branches, see two comments on the individual pull requests
though.

Given the date stamps on the commits, it seems like you've been sitting on
these for a while. Please try to send them in sooner in future release
cycles, it is perfectly OK to send a newer pull request for the same
branch with a few more patches on it later on (ideally with a new tag
describing the new portions). That way we don't get all the code so
late, and you run a lower risk of us being grumpy because several other
maintainers have also been late and we're slammed with merges.

The bulk of the material for the merge window really should be in arm-soc
by -rc6, with minor updates thereafter.


-Olof

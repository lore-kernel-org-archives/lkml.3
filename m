Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaLHXyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:54:06 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42806 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaLHXyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:54:05 -0500
X-Originating-IP: 50.43.43.148
Date: Mon, 8 Dec 2014 15:53:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@zytor.com, sam@ravnborg.org, bpoirier@suse.de, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3 0/2]: x86/arm64: add xenconfig
Message-ID: <20141208235354.GC15837@thin>
References: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 03:04:58PM -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This is based on some old set I had lying around. The virtconfig
> changes I had proposed a while ago got merged and reused for
> tinyconfig, this adapts my original set to use the new mergeconfig.
> 
> Not sure who's tree this should go through, last time these were
> lost in space and only the non-xen things got cherry picked later,
> who's tree should this go through?
> 
> Luis R. Rodriguez (2):
>   x86, platform, xen, kconfig: clarify kvmconfig is for kvm
>   x86, arm, platform, xen, kconfig: add xen defconfig helper

For both:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  arch/x86/configs/xen.config |  6 ++++++
>  kernel/configs/xen.config   | 32 ++++++++++++++++++++++++++++++++
>  scripts/kconfig/Makefile    |  7 ++++++-
>  3 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/configs/xen.config
>  create mode 100644 kernel/configs/xen.config
> 
> -- 
> 2.1.1
> 

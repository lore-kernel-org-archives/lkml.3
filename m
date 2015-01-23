Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbbAWAez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:34:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbbAWAex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:34:53 -0500
Date: Fri, 23 Jan 2015 01:34:50 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org,
        stefano.stabellini@eu.citrix.com, bpoirier@suse.de, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, julien.grall@linaro.org,
        rientjes@google.com
Subject: Re: [PATCH v3 0/2] x86/arm64: add xenconfig
Message-ID: <20150123003450.GV17887@wotan.suse.de>
References: <1421264027-10706-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421264027-10706-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:33:45AM -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This v3 addresses Stefano's feedback from the v2 series, namely
> moving PCI stuff to x86 as its all x86 specific and also just
> removing the CONFIG_TCG_XEN=m from the general config. To be
> clear the changes from the v2 series are below.
> 
> Luis R. Rodriguez (2):
>   x86, platform, xen, kconfig: clarify kvmconfig is for kvm
>   x86, arm, platform, xen, kconfig: add xen defconfig helper
> 
>  arch/x86/configs/xen.config | 10 ++++++++++
>  kernel/configs/xen.config   | 26 ++++++++++++++++++++++++++
>  scripts/kconfig/Makefile    |  7 ++++++-
>  3 files changed, 42 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/configs/xen.config
>  create mode 100644 kernel/configs/xen.config

Who could these changes go through?

  Luis

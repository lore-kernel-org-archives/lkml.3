Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaIHJZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:25:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:40997 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaIHJZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:25:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,486,1406592000"; 
   d="scan'208";a="170021354"
Message-ID: <540D7619.1000508@citrix.com>
Date: Mon, 8 Sep 2014 10:25:45 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <stefan.bader@canonical.com>,
        <toshi.kani@hp.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <ville.syrjala@linux.intel.com>, <hpa@zytor.com>, <x86@kernel.org>,
        <jbeulich@suse.com>, <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V2 3/3] Support Xen pv-domains using PAT
References: <1410163298-8951-1-git-send-email-jgross@suse.com> <1410163298-8951-4-git-send-email-jgross@suse.com>
In-Reply-To: <1410163298-8951-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 09:01, Juergen Gross wrote:
> With the dynamical mapping between cache modes and pgprot values it is
> now possible to use all cache modes via the Xen hypervisor PAT settings
> in a pv domain.
> 
> All to be done is to read the PAT configuration MSR and set up the
> translation tables accordingly.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

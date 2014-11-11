Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaKKKVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:21:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36414 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaKKKVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:21:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,360,1413244800"; 
   d="scan'208";a="191505328"
Message-ID: <5461E310.4070803@citrix.com>
Date: Tue, 11 Nov 2014 10:21:04 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V3 1/8] xen: Make functions static
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-2-git-send-email-jgross@suse.com>
In-Reply-To: <1415684626-18590-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 05:43, Juergen Gross wrote:
> Some functions in arch/x86/xen/p2m.c are used locally only. Make them
> static. Rearrange the functions in p2m.c to avoid forward declarations.
> 
> While at it correct some style issues (long lines, use pr_warn()).

Please don't add extra stuff like this.  In general if you feel yourself
wring "while at it..." or "also..." then you need another patch.

I also don't care about long lines if they are under 100 characters.

David


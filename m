Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaH2Obd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:31:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24343 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaH2Obb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:31:31 -0400
X-IronPort-AV: E=Sophos;i="5.04,424,1406592000"; 
   d="scan'208";a="166414826"
Message-ID: <54008EAE.2020601@citrix.com>
Date: Fri, 29 Aug 2014 15:31:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Kees Cook <keescook@chromium.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Solved the Xen PV/KASLR riddle
References: <20140827204940.GA10556@laptop.dumpdata.com> <1409248903-19625-1-git-send-email-stefan.bader@canonical.com> <20140829140823.GF3609@laptop.dumpdata.com> <54008DDA.3040701@canonical.com>
In-Reply-To: <54008DDA.3040701@canonical.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 15:27, Stefan Bader wrote:
> 
> Ok, I rework the patch and re-send it (freshly, iow not part of this thread).
> And while I am at it, I would add the stable tag.

Can you use a different title? Perhaps:

x86/xen: fix 64-bit PV guest kernel page tables for KASLR

David

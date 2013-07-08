Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3GHUPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:15:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3GHUPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:15:49 -0400
Message-ID: <51DB1D4D.7030308@zytor.com>
Date: Mon, 08 Jul 2013 13:13:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: remove unused Kconfig parameter
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com> <20130708192854.GF4927@phenom.dumpdata.com>
In-Reply-To: <20130708192854.GF4927@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 12:28 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 08, 2013 at 08:28:24AM +0200, Michael Opdenacker wrote:
>> This patch proposes to remove the XEN_PRIVILEGED_GUEST kernel
>> configuration parameter defined in arch/x86/xen/Kconfig, but used
>> nowhere in the makefiles and source code.
>>
>> This dummy parameter was added 3 years back, and it may
>> make sense to remove it now, as the reasons to use it were not
>> very clear.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> 
> Can't remove it. It is used by grub2.
> 

What the fsck does grub2 have to do with Kconfig?

	-hpa



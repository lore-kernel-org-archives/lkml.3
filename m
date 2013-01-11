Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3AKU1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:27:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51814 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab3AKU1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:27:22 -0500
Message-ID: <50F07588.90902@zytor.com>
Date: Fri, 11 Jan 2013 12:26:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com> <50E41973.9050705@citrix.com> <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl> <50E6F81D02000078000B3245@nat28.tlf.novell.com> <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl> <20130104191146.GC6721@phenom.dumpdata.com> <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl> <20130107162018.GJ3219@phenom.dumpdata.com> <87ehhsqrpr.fsf@xmission.com> <20130111165506.GD25620@phenom.dumpdata.com>
In-Reply-To: <20130111165506.GD25620@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> And there is nothing fancy to be done for EFI and SecureBoot? Or is
> that something that the kernel has to handle on its own (so somehow
> passing some certificates to somewhere).
>

For EFI, no... other than passing the EFI parameters, which apparently 
is *not* currently done (David Woodhouse is working on it.)  Secure boot 
is still a work in progress.


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


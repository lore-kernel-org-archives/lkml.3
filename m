Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3AKVPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:15:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52208 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab3AKVPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:15:21 -0500
Message-ID: <50F080C6.5070206@zytor.com>
Date: Fri, 11 Jan 2013 13:14:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
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
        David Howells <dhowells@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <50E6F81D02000078000B3245@nat28.tlf.novell.com> <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl> <20130104191146.GC6721@phenom.dumpdata.com> <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl> <20130107162018.GJ3219@phenom.dumpdata.com> <87ehhsqrpr.fsf@xmission.com> <20130111165506.GD25620@phenom.dumpdata.com> <87k3rjtqi7.fsf@xmission.com> <20130111205232.GC17126@redhat.com> <50F07E2D.6010602@zytor.com> <20130111210801.GC12019@redhat.com>
In-Reply-To: <20130111210801.GC12019@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:08 PM, Vivek Goyal wrote:
>>
>> A signed /sbin/kexec would realistically have to be statically linked,
>> at least in the short term; otherwise the libraries and ld.so would need
>> verification as well.
>
> Yes. That's the expectation. Sign only statically linked exeutables which
> don't do any of dlopen() stuff either.
>
> In fact in the patch, I fail the exec() if signed executable has
> interpreter.
>

As I said, though (and possibly not for kexec, that depends): in the 
long term we probably want a way to be able to sign all kinds binaries 
in the system.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


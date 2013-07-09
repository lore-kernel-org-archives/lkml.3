Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3GIPPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:15:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab3GIPPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:15:05 -0400
Message-ID: <51DC27BF.9090606@zytor.com>
Date: Tue, 09 Jul 2013 08:09:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, x86@kernel.org, tglx@linutronix.de,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, mingo@redhat.com,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com> <20130708192854.GF4927@phenom.dumpdata.com> <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com> <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic> <1373326534.1438.10.camel@x61.thuisdomein> <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com> <51DBDAB802000078000E37C1@nat28.tlf.novell.com> <20130709144840.GF24897@phenom.dumpdata.com> <20130709150554.GA27579@pd.tnic>
In-Reply-To: <20130709150554.GA27579@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 08:05 AM, Borislav Petkov wrote:
> On Tue, Jul 09, 2013 at 10:48:40AM -0400, Konrad Rzeszutek Wilk wrote:
>> Then that should be discussed on grub2 to remove said check and modify
>> the code so that it can properly work without regression.
> 
> Actually, the kernel patch removing that symbol should be applied so
> that grub2 breaks faster. One can't possibly rely on kernel internals
> for anything, as it is insanely insane (yep, the tautology is on purpose
> :-)).
> 

Indeed, especially since it inherently assumes something is a kernel
compile-time option... we routinely change things between compile time
and runtime.

	-hpa


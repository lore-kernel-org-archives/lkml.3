Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3HEQux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:50:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42649 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3HEQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:50:51 -0400
Date: Mon, 5 Aug 2013 12:50:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Wang <jasowang@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Doug Covelli <dcovelli@vmware.com>, Borislav Petkov <bp@suse.de>,
        Dan Hecht <dhecht@vmware.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@linuxdriverproject.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 4/4] x86: correctly detect hypervisor
Message-ID: <20130805165016.GB22093@phenom.dumpdata.com>
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
 <1374742475-2485-4-git-send-email-jasowang@redhat.com>
 <51FF1E26.6010707@redhat.com>
 <20130805143426.GH3321@phenom.dumpdata.com>
 <51FFC2D5.70105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFC2D5.70105@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 08:20:53AM -0700, H. Peter Anvin wrote:
> On 08/05/2013 07:34 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > Could you provide me with a git branch so I can test it overnight please?
> > 
> 
> Pull tip:x86/paravirt.

It works for me. Thanks.
> 
> 	-hpa
> 
> 

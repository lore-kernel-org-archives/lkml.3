Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3HEPVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:21:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53625 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab3HEPVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:21:34 -0400
Message-ID: <51FFC2D5.70105@zytor.com>
Date: Mon, 05 Aug 2013 08:20:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jason Wang <jasowang@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
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
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com> <1374742475-2485-4-git-send-email-jasowang@redhat.com> <51FF1E26.6010707@redhat.com> <20130805143426.GH3321@phenom.dumpdata.com>
In-Reply-To: <20130805143426.GH3321@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 07:34 AM, Konrad Rzeszutek Wilk wrote:
> 
> Could you provide me with a git branch so I can test it overnight please?
> 

Pull tip:x86/paravirt.

	-hpa



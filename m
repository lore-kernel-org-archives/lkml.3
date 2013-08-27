Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3H0IKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:10:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:48500 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3H0IKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:10:21 -0400
Message-ID: <1377588905.3819.115.camel@pasglop>
Subject: Re: [PATCH 02/10] KVM: PPC: reserve a capability number for
 multitce support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Tue, 27 Aug 2013 17:35:05 +1000
In-Reply-To: <20130827064114.GC22899@redhat.com>
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru>
	 <1375332272-22176-3-git-send-email-aik@ozlabs.ru>
	 <1376441474.4255.39.camel@pasglop> <20130826123753.GA22977@redhat.com>
	 <1377577198.3819.102.camel@pasglop> <1377577362.3819.103.camel@pasglop>
	 <20130827064114.GC22899@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 09:41 +0300, Gleb Natapov wrote:
> > Oh and Alexey mentions that there are two capabilities and you only
> > applied one :-)
> > 
> Another one is:
>  [PATCH v8] KVM: PPC: reserve a capability and ioctl numbers for
> realmode VFIO
> ?

Yes, thanks !

Cheers,
Ben.



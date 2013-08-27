Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3H0GlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3H0GlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:41:23 -0400
Date: Tue, 27 Aug 2013 09:41:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH 02/10] KVM: PPC: reserve a capability number for multitce
 support
Message-ID: <20130827064114.GC22899@redhat.com>
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru>
 <1375332272-22176-3-git-send-email-aik@ozlabs.ru>
 <1376441474.4255.39.camel@pasglop>
 <20130826123753.GA22977@redhat.com>
 <1377577198.3819.102.camel@pasglop>
 <1377577362.3819.103.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377577362.3819.103.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:22:42PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2013-08-27 at 14:19 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2013-08-26 at 15:37 +0300, Gleb Natapov wrote:
> > > > Gleb, any chance you can put this (and the next one) into a tree to
> > > > "lock in" the numbers ?
> > > > 
> > > Applied it. Sorry for slow response, was on vocation and still go
> > > through the email backlog.
> > 
> > Thanks. Since it's not in a topic branch that I can pull, I'm going to
> > just cherry-pick them. However, they are in your "queue" branch, not
> > "next" branch. Should I still assume this is a stable branch and that
> > the numbers aren't going to change ?
> 
> Oh and Alexey mentions that there are two capabilities and you only
> applied one :-)
> 
Another one is:
 [PATCH v8] KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
?

--
			Gleb.

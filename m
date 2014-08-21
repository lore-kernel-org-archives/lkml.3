Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaHUNtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbaHUNtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:49:39 -0400
Date: Thu, 21 Aug 2014 15:49:17 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 5/6] KVM: trace kvm_ple_window
Message-ID: <20140821134916.GF20453@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-6-git-send-email-rkrcmar@redhat.com>
 <53F5ADE6.30106@redhat.com>
 <20140821115637.GE20546@potion.brq.redhat.com>
 <53F5F2AA.7060600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5F2AA.7060600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 15:22+0200, Paolo Bonzini:
> Il 21/08/2014 13:56, Radim Krčmář ha scritto:
> > 2014-08-21 10:29+0200, Paolo Bonzini:
> >> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> >>> +	TP_PROTO(int grow, unsigned int vcpu_id, int new, int old),
> >>
> >> s/int grow/bool grow/ (and similarly in TP_STRUCT__entry).
> > 
> > Ok.
> > (We are using 'int' for this in other tracepoints, so I guessed there is
> >  some hate agains bool.)
> 
> Yeah, there are many ints, but there are also some bools. :)
> 
> Of course "bool" is only a no-brainer if there is a clear direction to
> use (e.g. "bool has_error"), and indeed this case is less obvious.  But
> there are some like this one (e.g. bool gpa_match).
> 
> Keep the int if you prefer it that way.

I actually like bool much better, but first few were only int and then I
stopped looking ...

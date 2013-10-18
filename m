Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3JRHc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab3JRHc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:32:28 -0400
Date: Fri, 18 Oct 2013 09:29:45 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 4/7] static_key: use static_key_slow_inc_deferred()
Message-ID: <20131018072906.GA24108@hpx.cz>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
 <1382004631-25895-5-git-send-email-rkrcmar@redhat.com>
 <525FBE4B.9060206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <525FBE4B.9060206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-17 12:39+0200, Paolo Bonzini:
> Il 17/10/2013 12:10, Radim Krčmář ha scritto:
> > Simple replacement where possible.
> > Saves us problematic access to the structure and allows optimalizations
> > and bug fixes to take place.
> 
> I think you should introduce this first as a simple wrapper around
> static_key_slow_inc, and then add the bells and whistles you have in
> patches 2 and 3.

Ok, thanks.

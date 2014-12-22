Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaLVOJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:09:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbaLVOJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:09:41 -0500
Date: Mon, 22 Dec 2014 12:09:24 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning up the KVM clock
Message-ID: <20141222140924.GA10176@amt.cnet>
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
 <20141222133430.GA23631@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222133430.GA23631@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:34:30AM -0200, Marcelo Tosatti wrote:
> > It would be even nicer, though, if we could do much the same thing but
> > without worrying about which vcpu we're on.
> > 
> > Thoughts?  Am I missing some considerations here?
> 
> Maybe we can find another optimization opportunities?

Perhaps RDTSCP rather than getcpu is a win?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3EBSTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:19:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47431 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761207Ab3EBSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:19:04 -0400
Date: Thu, 2 May 2013 11:19:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, bp@alien8.de, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <5182AB66.6020307@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1305021115500.2493@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, H. Peter Anvin wrote:

> Let's drop this one for right now.  I need to queue up some actual
> urgent fixes...
> 

Sounds good.  I think what you eluded to earlier, a "select" that resolves 
dependencies on the symbols it enables, would be the best way to implement 
something like KVM_GUEST_COMMON_OPTIONS so that it doesn't pick up a 
failure when an option it selects adds a new dependency.  It would reduce 
the size of this particular patch considerably and avoid constantly 
updating its list.

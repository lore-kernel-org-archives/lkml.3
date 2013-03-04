Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3CDRqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab3CDRqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:46:47 -0500
Date: Mon, 4 Mar 2013 12:46:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130304174628.GC15199@redhat.com>
References: <20130228213534.GF11360@redhat.com>
 <CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
 <1362102544.9158.35.camel@falcor1>
 <1362140107.9158.101.camel@falcor1>
 <20130301152839.GA3457@redhat.com>
 <20130301184027.GB3457@redhat.com>
 <1362166753.9158.169.camel@falcor1>
 <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
 <20130304152919.GA15199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304152919.GA15199@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:29:19AM -0500, Vivek Goyal wrote:

[..]
> This reduces our options but trying to make multiple policies co-exist
> together is just making it complicated. We can take it up again when
> somebody has a strong use case of using secureboot policy along with
> other policies.

Well, I also see the unused hook for module verification. Right now there
is no policy for that but if we ever decide to do module verification
using ima hook, then we will have this question that where does that
rule go in now.

Thanks
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab3GPQpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:45:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab3GPQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:45:33 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=VwQbUJbxAAAA:8 a=93az3msDwVXhht_yl7UA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373993130.6458.13.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: David Lang <david@lang.hm>
Cc: Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 12:45:30 -0400
In-Reply-To: <alpine.DEB.2.02.1307152319490.16723@nftneq.ynat.uz>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <alpine.DEB.2.02.1307152319490.16723@nftneq.ynat.uz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:24 -0700, David Lang wrote:

> Just because some crazy person ;-) decides to maintain 2.4 for many years 
> doesn't mean that every subsystem maintainer needs to worry about backporting 
> patches from 3.11 all the way back to 2.4. The fact that they are as willing as 
> they are to review the results of the backports for problems in amazing.

Any "process" that we come up with for maintainers with respect to the
stable tree, should only matter to the official ones "last release" and
"last release-1". All others are the responsibility of those maintaining
it. Long term stable trees shouldn't burden the maintainer unless they
want to help.

I don't expect much help from maintainers for the 3.6 stable I maintain.
Any help I do get I'm greatly appreciated of. I also love it when
maintainers add which versions of the kernel a bug fix goes back too.
That is, I love seeing

 Cc: stable@vger.kernel.org # 3.2+

instead of just:

 Cc: stable@vger.kernel.org


But even that, I'm glad to see and don't expect to. The maintainers
don't need that burden as well. I'll read the change log and try to
figure out if it's required or not. And if it applies, I add it,
otherwise, I skip it.

-- Steve



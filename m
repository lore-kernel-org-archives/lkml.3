Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3IDPnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:43:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868Ab3IDPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:43:52 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=f7rjvp014JQA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0_tXc69lpkgA:10 a=r_1tXGB3AAAA:8 a=FQotgy6LNao3A2EdKDEA:9 a=CjuIK1q_8ugA:10 a=EDSpbFuiShEA:10 a=CEQgAvWhMlUA:10 a=ysHM2seXnQYA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 4 Sep 2013 11:43:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 13/25] mips: Use Kbuild infrastructure to handle
 asm-generic headers
Message-ID: <20130904114350.07a40c95@gandalf.local.home>
In-Reply-To: <5224529D.10009@imgtec.com>
References: <20121013022632.024527228@goodmis.org>
	<20121013022954.289710602@goodmis.org>
	<5224529D.10009@imgtec.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013 09:55:57 +0100
James Hogan <james.hogan@imgtec.com> wrote:

> On 13/10/12 03:26, Steven Rostedt wrote:

> Also note, as I said in the commit message:
> >     We can't do the same for uapi/asm/kvm_para.h because it's presence is
> >     explicitly checked in include/uapi/linux/Kbuild to decide whether to add
> >     kvm_para.h to header-y.
> 
> so I guess that may need fixing first before half of these patches can
> be accepted.
> 

Sure.

Thanks,

-- Steve

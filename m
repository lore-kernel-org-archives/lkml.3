Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaDXCss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaDXCsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:48:47 -0400
Date: Thu, 24 Apr 2014 10:50:16 +0800
From: Dave Young <dyoung@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kaslr should avoid setup_data region
Message-ID: <20140424025016.GB2180@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
 <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/14 at 07:43pm, Kees Cook wrote:
> On Wed, Apr 23, 2014 at 7:35 PM, Dave Young <dyoung@redhat.com> wrote:
> > Hello Kees
> >
> > I'm worrying that setup_data regions could be overwitten by randomize
> > kernel base. Would you like to fix it in kaslr code?
> >
> > One problem is there could be a lot of setup_data regions but current
> > mem_avoid is an fixed array.
> 
> Sure, can you give me some examples? Seems like it shouldn't be too
> hard to have the mem_avoid logic walk additional areas.

Great, To walk through the list just like the function parse_setup_data in
arch/x86/kernel/setup.c

Thanks
Dave

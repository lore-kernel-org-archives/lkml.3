Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaEEI53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbaEEI52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:57:28 -0400
Date: Mon, 5 May 2014 16:58:55 +0800
From: Dave Young <dyoung@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kaslr should avoid setup_data region
Message-ID: <20140505085855.GC3897@darkstar.nay.redhat.com>
References: <20140424023544.GA2180@darkstar.nay.redhat.com>
 <CAGXu5j+TP2=iVYj=a6YGiGdOUqznb1MxdLLz5tjL8Hwwcq2K0Q@mail.gmail.com>
 <20140424025016.GB2180@darkstar.nay.redhat.com>
 <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKaog6X+jw6Zh3iHSHS8KFUbLEHm75=HbVORJ-crpr7Fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I won't be in a position to test EFI booting for a while. If someone
> else took this, that would make it get fixed much faster.

I will hopefully look into it next week. But as I said I can only test
with a hacked kernel which set the randomized addr to the setup_data region.

Thanks
Dave 

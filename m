Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab3LXVNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 16:13:12 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41152 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3LXVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 16:13:10 -0500
Date: Tue, 24 Dec 2013 13:13:01 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Neuling <michael@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
Message-ID: <20131224211301.GA20469@linux.vnet.ibm.com>
References: <1387820970-6949-1-git-send-email-ard.biesheuvel@linaro.org>
 <CA+55aFwbrdgO_=LQ5=p2J=QmX_BmCvNbGGcxS0C0dKqocAkfYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwbrdgO_=LQ5=p2J=QmX_BmCvNbGGcxS0C0dKqocAkfYA@mail.gmail.com>
X-Operating-System: Linux 3.11.0-14-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122421-7164-0000-0000-0000048F80C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2013 [17:37:00 -0800], Linus Torvalds wrote:
> Please cc the guilty parties when sending patches like this.
> 
> Also, just out of interest, please describe how this bug affected
> things. Did we overflow the saved_auxv[] array, or what? Also, how
> does this change affect architectures that _don't_ have that
> ELF_HWCAP2 thing, ie everything but powerpc?
> 
> Acks, people?

Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

I agree with Mikey that a comment might be useful. Thanks for the fix
and sorry for the mistake!

-Nish


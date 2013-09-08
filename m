Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3IHRdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:33:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59759 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab3IHRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:32:59 -0400
Message-ID: <1378661576.2429.16.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Date: Sun, 08 Sep 2013 10:32:56 -0700
In-Reply-To: <1378661252.2300.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
	 <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
	 <1378661252.2300.26.camel@x230>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-08 at 17:27 +0000, Matthew Garrett wrote:
> > It's an argument that CAP_SYS_BOOT is too powerful yes, but if you
> > recall, I said I keep that one.  In the rather lame analogy, what I do
> > by giving away CAP_SYS_MODULE and enforcing module signing while keeping
> > CAP_SYS_BOOT is allow people into my conservatory to play with the
> > plants but not into my house to steal the silver ... saying CAP_SYS_BOOT
> > is too powerful doesn't affect that use case because I haven't given
> > away CAP_SYS_BOOT.
> 
> Ok, sorry, I had your meaning inverted. Yes, permitting the loading of
> signed modules while preventing the use of kexec is a completely
> reasonable configuration - so reasonable that it's what this patch
> causes the kernel to do automatically. 

Well, no, it doesn't because with this patch, *I* can't use kexec ...
you've just locked me out of my own house.

James



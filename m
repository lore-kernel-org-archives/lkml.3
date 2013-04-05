Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162235Ab3DERh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:37:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33090 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162202Ab3DERh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:37:56 -0400
Date: Fri, 5 Apr 2013 10:37:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Puff ." <puff65537@bansheeslibrary.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivers/staging/silicom/bp_proc.c removal
Message-ID: <20130405173754.GA18933@kroah.com>
References: <20130404191245.GT21522@ZenIV.linux.org.uk>
 <CAN4nR9cuvPgNK++N2=Mz3sifeuBfRtKdAEQ8m6MhcSvQVKn-Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN4nR9cuvPgNK++N2=Mz3sifeuBfRtKdAEQ8m6MhcSvQVKn-Sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 10:31:56AM -0700, Puff . wrote:
> No reason not to.
> 
> ~~~~~~
> DanielC
> 
> On Thu, Apr 4, 2013 at 12:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
>             It's all ifdefed out (on BYPASS_SUPPORT), severely bitrotten (try
>     to remove the ifdef and watch what happens on attempt to build) and,
>     AFAICS,
>     it's a duplicate of the stuff in bp_mod.c.
> 
>             Is there any reason to keep it around?  IOW, how about
>     git rm drivers/staging/silicom/bp_proc.c
>     git mv drivers/staging/silicom/bp{,ctl}_mod.c
>     ed drivers/staging/silicom/Makefile <<EOF
>     /bp_proc/d
>     wq
>     EOF
>     and if anybody needs to see what used to be there, git history is enough...

Ok, I'll go do that later today, thanks.

greg k-h

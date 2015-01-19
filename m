Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbASSLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:11:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:53084 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752320AbbASSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:11:02 -0500
Date: Mon, 19 Jan 2015 13:10:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option on
 Super-H
Message-ID: <20150119181059.GB25043@home.goodmis.org>
References: <1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
 <20150119175125.GA25043@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119175125.GA25043@home.goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with Matt's current email address.

-- Steve

On Mon, Jan 19, 2015 at 12:51:25PM -0500, Steven Rostedt wrote:
> 
> Matt,
> 
> You initially added this code. Are you OK with this change?
> 
> -- Steve
> 
> On Sun, Jan 18, 2015 at 12:36:15AM +0100, Michael Karcher wrote:
> > Signed-Off-By: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> > ---
> >  scripts/recordmcount.pl | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 56ea99a..537c38c 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -255,7 +255,6 @@ if ($arch eq "x86_64") {
> >      # force flags for this arch
> >      $ld .= " -m shlelf_linux";
> >      $objcopy .= " -O elf32-sh-linux";
> > -    $cc .= " -m32";
> >  
> >  } elsif ($arch eq "powerpc") {
> >      $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
> > -- 
> > 2.1.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

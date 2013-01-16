Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3APVfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:35:48 -0500
Received: from ac250205.ppp.asahi-net.or.jp ([183.77.250.205]:54222 "EHLO
	smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3APVfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:35:47 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 16:35:47 EST
Date: Thu, 17 Jan 2013 06:29:56 +0900
From: Mattia Dongili <malattia@linux.it>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        platform-driver-x86@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] x86 platform driver bugfixes for 3.8
Message-ID: <20130116212956.GA21553@kamineko.org>
References: <20130107171722.GA31427@srcf.ucam.org>
 <CA+55aFzL00K+oURqcnSgbAAkD18DJ8-p1G8vd7KE6RD77dLmCQ@mail.gmail.com>
 <20130107172616.GB31427@srcf.ucam.org>
 <20130107174306.GC31427@srcf.ucam.org>
 <87ehhlifae.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87ehhlifae.fsf@nemi.mork.no>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.7.0+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:38:17AM +0100, Bjørn Mork wrote:
> Matthew Garrett <matthew.garrett@nebula.com> writes:
> 
> > This set covers regressions and two obvious bugfixes. The rest can wait 
> > for 3.9.
> 
> Hello Matthew,
> 
> may I request that you include the patch
> 
>       sony-laptop: fully enable SNY controlled modems
> 
> for 3.8 as well?  I'd even like it to go to stable if you and Mattia
> agree.

Yes, my initial intent was to have it in 3.7 as a bugfix. The
sony-laptop driver manages to disable the wwan device correctly but
fails to re-enable it afterwards.

-- 
mattia
:wq!

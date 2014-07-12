Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaGLBq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:46:57 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:39238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752029AbaGLBq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:46:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:901:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2538:2553:2560:2563:2682:2685:2741:2828:2859:2895:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3657:3865:3866:3867:3868:3870:3871:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:7652:7875:7903:8550:9025:10004:10049:10400:10848:11232:11257:11658:11854:11914:12043:12114:12517:12519:12555:12679:12740:13069:13095:13160:13180:13229:13311:13357:13
X-HE-Tag: sheep66_59543be9bcc24
X-Filterd-Recvd-Size: 2817
Message-ID: <1405129612.6751.24.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 11 Jul 2014 18:46:52 -0700
In-Reply-To: <20140712013927.GA30781@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712013927.GA30781@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:39 -0700, Greg KH wrote:
> On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > A simple script to run checkpatch --fix for various types of
> > of cleanups.
]
> drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.
> file: <drivers/staging/lustre/include/linux/lnet/api.h> description: <update c90 comment style> types:<c99_comments>
> Useless use of greediness modifier '+' in regex; marked by <-- HERE in m/(^\+.*) {8,8}+ <-- HERE \t/ at ./scripts/checkpatch.pl line 2217.
[]
> drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.
[]
> Is that expected?

No, I haven't seen that.

Can you tell me what git tree you're working on?
Also, can you use the scripts/checkpatch from -next
tag next-20140711

My system has:

$ perl --version 

This is perl 5, version 18, subversion 2 (v5.18.2) built for i686-linux-gnu-thread-multi-64int
(with 41 registered patches, see perl -V for more detail)

Copyright 1987-2013, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.

and using that:

$ ./scripts/checkpatch.pl -f --strict drivers/staging/lustre/include/linux/lnet/api.h --types=c99_comments
total: 0 errors, 0 warnings, 0 checks, 220 lines checked

NOTE: Used message types: C99_COMMENTS

drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.



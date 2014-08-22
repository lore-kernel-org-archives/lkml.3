Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaHVB1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:27:17 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:42518 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbaHVB1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:27:15 -0400
Date: Fri, 22 Aug 2014 10:27:01 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: Make scripts executable
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <53F5BCC8.4060000@suse.cz>
References: <20140821122521.2D67.AA925319@jp.panasonic.com> <53F5BCC8.4060000@suse.cz>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140822102701.2D80.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Thu, 21 Aug 2014 11:32:56 +0200
Michal Marek <mmarek@suse.cz> wrote:

> On 2014-08-21 05:25, Masahiro Yamada wrote:
> > Hi Michal,
> > 
> > 
> > On Wed, 20 Aug 2014 16:10:48 +0200
> > Michal Marek <mmarek@suse.cz> wrote:
> > 
> >> The Makefiles call the respective interpreter explicitly, but this makes
> >> it easier to use the scripts manually.
> >>
> >> Signed-off-by: Michal Marek <mmarek@suse.cz>
> > 
> > 
> > I am not sure at all, but
> > it seems scripts/checkpatch.pl has a rule
> > to ban execute permissions.
> 
> I didn't know about this, but the intent of the rule seems to be to
> avoid *.c files with execute permissions.
> 
> 
> > # Check for incorrect file permissions
> >                 if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
> >                         my $permhere = $here . "FILE: $realfile\n";
> >                         if ($realfile !~ m@scripts/@ &&
> >                             $realfile !~ /\.(py|pl|awk|sh)$/) {
> 
> Here it explicitly skips files below scripts/ and files with known
> script suffixes.
> 

OK then. I replied without understanding this code well.
My appologies.


Best Regards
Masahiro Yamada


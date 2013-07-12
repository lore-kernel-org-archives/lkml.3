Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3GLCRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:17:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3GLCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:17:39 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xFf7jPuUPC8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=f3b2Vskq_a13c5GH3xgA:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=1TSTQ8KKaH4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373595458.17876.83.camel@gandalf.local.home>
Subject: Re: [ 00/11] 3.4.53-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Date: Thu, 11 Jul 2013 22:17:38 -0400
In-Reply-To: <20130712003346.GA10248@kroah.com>
References: <20130711220545.542911892@linuxfoundation.org>
	 <CAP=VYLqgAF=RL9BcemhQH_qN8c8n9vud2QfPkMskH-rBMd35UA@mail.gmail.com>
	 <20130712003346.GA10248@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 17:33 -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2013 at 08:24:33PM -0400, Paul Gortmaker wrote:
> > On Thu, Jul 11, 2013 at 6:11 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 3.4.53 release.
> > > There are 11 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat Jul 13 22:04:03 UTC 2013.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.53-rc1.gz
> > 
> > Just happened to notice the v3.0 in the path vs. the 3.4 version.
> > Wasn't sure that was intentional or not, so figured I'd mention it.
> 
> It's intentional, it's always been there, but I guess I could use the
> 3.x link instead, they both point to the same place.
> 

I can vouch for it always being there. I had to add a work around in my
-rt scripts to test if it was 3.0 or > 3.0, to determine what to post as
the patch set to get to an -rt kernel:

Or to build 3.0.85-rt113 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.85.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.85-rt113.patch.xz


Or to build 3.4.52-rt67 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.52.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.52-rt67.patch.xz


Note, it's not just with stable, it's also with the main kernel tree too.

But it seems today they are the same directory. I think it wasn't like
that before the break in. Otherwise, I doubt I would have spent time on
that work around.

-- Steve





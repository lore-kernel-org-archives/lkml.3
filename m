Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3CMN4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab3CMN4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:56:37 -0400
Date: Wed, 13 Mar 2013 09:56:32 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v5 4/4] devcg: propagate local changes down the hierarchy
Message-ID: <20130313135632.GA4417@redhat.com>
References: <20130215165543.131282532@napanee.usersys.redhat.com>
 <20130215165543.733711059@napanee.usersys.redhat.com>
 <20130219211208.GC5399@mail.hallyn.com>
 <20130219212015.GF11173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219212015.GF11173@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
On Tue, Feb 19, 2013 at 04:20:16PM -0500, Aristeu Rozanski wrote:
> On Tue, Feb 19, 2013 at 09:12:08PM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris@redhat.com):
> > > +		} else {
> > > +			/*
> > > +			 * in the other possible cases:
> > > +			 * root's behavior: allow, devcg's: deny
> > > +			 * root's behavior: deny, devcg's: deny
> > > +			 * the exception will be removed
> > > +			 */
> > 
> > Technically this case isn't needed, right?  Will the dev_exception_rm()
> > also be done by revalidate_active_exceptions()?  So it's safe (but
> > not necessary) to drop the else here.  Though the comment is very
> > informative, and it might be worth keeping the code as is for clarity.
> 
> that's correct, it'll end up being removed by
> revalidate_active_exceptions(). if others have no objection, I'll keep
> it
> 
> Thanks for the reviews Serge, much appreciated

did you pick this series up for 3.10 or you want me to resubmit?

-- 
Aristeu


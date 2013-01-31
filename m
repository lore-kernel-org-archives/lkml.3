Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3AaPNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:13:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3AaPNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:13:36 -0500
Date: Thu, 31 Jan 2013 10:13:32 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Message-ID: <20130131151331.GM17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.253395279@napanee.usersys.redhat.com>
 <20130130204730.GF8507@mail.hallyn.com>
 <20130130204917.GL17632@redhat.com>
 <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:50:38PM -0800, Tejun Heo wrote:
> On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
> intentional. thanks for catching this
> >
> > Tejun, you want me to resubmit the whole series or just the next patch
> > (where I was supposed to move that chunk)?
> 
> If it doesn't affect the next patch, just posting an updated version
> of this patch should be enough, I think. Which tree are these patches
> planned to go through?

the fix should actually happen on the next patch, not this one. and it
seems I'll have to refresh it anyway (just had a glance on Serge's
emails).

-- 
Aristeu


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3CGPky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:40:54 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45306 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3CGPkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:40:52 -0500
Message-ID: <1362670833.4392.438.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Thu, 07 Mar 2013 10:40:33 -0500
In-Reply-To: <20130307143643.GA2790@redhat.com>
References: <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
	 <1362446491.4392.133.camel@falcor1> <20130305151829.GB4519@redhat.com>
	 <1362516018.4392.233.camel@falcor1> <20130305215300.GE4519@redhat.com>
	 <1362584551.4392.291.camel@falcor1> <20130306235525.GB29229@redhat.com>
	 <1362620348.4392.408.camel@falcor1> <20130307143643.GA2790@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030715-7182-0000-0000-000005AF04CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 09:36 -0500, Vivek Goyal wrote:
> On Wed, Mar 06, 2013 at 08:39:08PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-03-06 at 18:55 -0500, Vivek Goyal wrote:
> > > On Wed, Mar 06, 2013 at 10:42:31AM -0500, Mimi Zohar wrote:
>  
> > Adding an IMA call to directly appraise the integrity of a file, rather
> > than adding a hook, prevents other integrity users from being able to
> > define a rule at that point.
> 
> We already have security hooks in exec() code and mmap(). And current
> integrity callers are happy with it.

Exposing integrity calls, resolves the problem of code duplication, but
does not address Rusty's third issue of improving the integrity
subsystem.  You have no idea if the existing integrity users are happy
with the status quo.  It's there and they're using it.  They could want
additional hooks or better located hooks.  Each of your complaints about
the integrity subsystem could be addressed and would improve the
subsystem.

thanks,

Mimi


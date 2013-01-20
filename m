Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3ATRUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 12:20:09 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51292 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3ATRUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 12:20:08 -0500
Message-ID: <1358702400.2406.103.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
Date: Sun, 20 Jan 2013 12:20:00 -0500
In-Reply-To: <20130117173605.GB2237@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <1358437021.2689.52.camel@falcor1> <20130117155154.GC12165@redhat.com>
	 <1358440365.2689.72.camel@falcor1> <20130117173605.GB2237@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012017-7182-0000-0000-000004928710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 12:36 -0500, Vivek Goyal wrote:
> On Thu, Jan 17, 2013 at 11:32:45AM -0500, Mimi Zohar wrote:
> 
> [..]
> > > > At this point, why would you want yet another method for signing files?
> > > 
> > > Are you saying that append signature instead of putting them in a section
> > > or are you saying that just use IMA.
> > > 
> > > - For the first, I am fine with appending too if that works better. So
> > >   what's wrong with current implementation. Just because we append the
> > >   signatures in case of modules, we should follow the same thing for
> > >   executables too?
> > 
> > No, I was saying that if this patch set were to be upstreamed, then the
> > signature verification, at least for ELF modules and ELF executables,
> > should be the same.  The patch would then be a lot smaller.
> 
> I don't think that patch is lot smaller. Initially I had written code
> where signatures were appended. Parsing the signature is little different
> from module. In case of modules, whole file is already in memory and
> in case of executables, we are reading selected portions of file in
> buffer. 

Have you looked at the original kernel module signature verification
code as posted by David?  It did something similar, but was not
upstreamed.

thanks,

Mimi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab3EONct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002Ab3EONcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:32:47 -0400
Message-ID: <1368624762.27262.1.camel@localhost>
Subject: Re: linux-next: build warning after merge of the final tree (in
 Linus' tree)
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>
Date: Wed, 15 May 2013 09:32:42 -0400
In-Reply-To: <20130515132001.6cc824ba42106db973f90991@canb.auug.org.au>
References: <20130515132001.6cc824ba42106db973f90991@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 13:20 +1000, Stephen Rothwell wrote:
> Hi ,
> 
> After merging the final tree, today's linux-next build (i386 defconfig)
> produced this warning:
> 
> kernel/auditfilter.c: In function 'audit_data_to_entry':
> kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]
> 
> Introduced by commit 780a7654cee8 ("audit: Make testing for a valid
> loginuid explicit") from Linus' tree.

Thank you, I'll fix it up.  What am I likely missing that I don't see it
on my builds?  I'm using gcc 4.8.  Is there a config option that enables
additional warnings?


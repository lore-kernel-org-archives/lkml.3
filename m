Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbbALPHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbbALPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:07:16 -0500
From: Paul Moore <pmoore@redhat.com>
To: "Christopher J. PeBenito" <cpebenito@tresys.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Dave Jones <davej@codemonkey.org.uk>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        selinux <selinux@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: noisy selinux messages on tmpfs mount.
Date: Mon, 12 Jan 2015 10:06:43 -0500
Message-ID: <10532721.yu8lhX206e@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54B3DF65.809@tresys.com>
References: <20150108190822.GB4365@codemonkey.org.uk> <54B03E45.8000106@tycho.nsa.gov> <54B3DF65.809@tresys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2015 09:51:17 AM Christopher J. PeBenito wrote:
> On 1/9/2015 3:47 PM, Stephen Smalley wrote:
> > On 01/09/2015 02:13 PM, Dave Jones wrote:
> >> That doesn't really help with the flooding of dmesg, so no.
> >> I should also note that it's not just logging in that creates a new
> >> session, it also seems to be getting triggered by cron jobs, or
> >> whatever the systemd replacement is.
> > 
> > Fair enough.  I think we can likely get rid of it then.
> 
> Are you saying completely get rid of the message in all cases?  If so,
> how is a user supposed to debug situations where they mount a filesystem
> and labeling doesn't work (i.e. no security label support or policy
> hasn't been updated for that fs)?

I'm pretty sure Stephen just meant the normal case, not the "unknown behavior" 
case.

> Is there going to be another place to look see what the labeling behavior is
> for all mounted filesystems?

I imagine we could create something in securityfs for that, you want to write 
a patch Chris? :)

-- 
paul moore
security @ redhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbAUQQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:16:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbbAUQQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:16:37 -0500
From: Paul Moore <pmoore@redhat.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Wed, 21 Jan 2015 11:16:23 -0500
Message-ID: <6942214.D1ODllqz3j@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150121155407.GA18701@kria>
References: <20150120165655.GA10904@kria> <20150121153910.GD22884@ulmo.nvidia.com> <20150121155407.GA18701@kria>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 04:54:07 PM Sabrina Dubroca wrote:
> 2015-01-21, 16:39:12 +0100, Thierry Reding wrote:
> > That doesn't seem to help, at least in my case.
> 
> Same here.

Okay, thanks for trying.  Sorry that didn't resolve things.

> Well, it's probably not an audit issue.  I tried audit=0 on the
> commandline, and I just rebuilt a kernel with CONFIG_AUDIT=n, and it's
> still panicing.  This should have fixed any audit-related issue,
> right?

Most likely.  Back to the code I go ...

-- 
paul moore
security @ redhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbbANQpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:45:16 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45159 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbANQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:45:13 -0500
Date: Wed, 14 Jan 2015 22:14:58 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Subject: Re: NBD Maintainer
Message-ID: <20150114164458.GA2152@fool>
References: <CAECXXi7Ax3t2b7x=KqUF1udNKWgQnGebVtkyLHnjhxEZ2o=M5g@mail.gmail.com>
 <CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
 <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 02:26:01PM -0500, Paul Clements wrote:
> On Tue, Jan 13, 2015 at 11:14 AM, Andrey Utkin
> <andrey.krieger.utkin@gmail.com> wrote:
> > Hi Paul,
> > could you please describe
> 
> > - how wide is NBD usage today (any estimation is ok),
> 
> It depends somewhat on who you consider to be users. There are two
> groups of NBD "users":
> 
> 1) integrators and admins (who work directly with nbd)
> 2) users of the systems and software that the first group creates

Hi Paul,
studied the driver code. looks like the driver is simple and the main work is being done by the nbd-client and nbd-server.
i was thinking of putting in my name for consideration, but being a newbie in lkml (have worked with drivers and server-client codes in my dayjob)
and seeing the vast user base i am not sure anymore. But will like to try if you are there for guidance.

sudip

> 
> My guess is that the first group is in the hundreds. The second in the
> thousands. NBD usage tends to fall into one the following classes:
> 


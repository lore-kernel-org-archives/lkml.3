Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab3HGWCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609Ab3HGWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:02:31 -0400
Message-ID: <5202C3EF.4090501@redhat.com>
Date: Wed, 07 Aug 2013 17:02:23 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 0/7] uselex.rb as a tiny tool to find dead code
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/13 4:43 PM, Sergei Trofimovich wrote:

...

> Meet uselex.rb: one-file script to parse 'nm' output:
> 
>     https://github.com/trofi/uselex/blob/master/uselex.rb

Nice to meet you!  I think I've met your close relative,
ftp://ftp.samba.org/pub/unpacked/junkcode/findstatic.pl  :)

#!/usr/bin/perl -w
# find a list of fns and variables in the code that could be static
# usually called with something like this:
#    findstatic.pl `find . -name "*.o"`
# Andrew Tridgell <tridge@samba.org>

(just FWIW)

-Eric


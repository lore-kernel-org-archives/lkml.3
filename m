Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbaDWTFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbaDWTFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:05:35 -0400
Date: Wed, 23 Apr 2014 15:05:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        lpoetter@redhat.com, kay@redhat.com, Daniel Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP
 socket options
Message-ID: <20140423190532.GE22755@redhat.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
 <20140422.160558.627080587952506099.davem@davemloft.net>
 <CALCETrWHA5ZmzOHnz9LO+7v4byc8QiynGyjE_ju5sjokNqrjZA@mail.gmail.com>
 <20140422.162927.2182797573155988911.davem@davemloft.net>
 <CALCETrX_TCbKy-3W590wG3rq9O3Hzbqc_wu3EGg7PKn2NNsTpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX_TCbKy-3W590wG3rq9O3Hzbqc_wu3EGg7PKn2NNsTpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:31:13PM -0700, Andy Lutomirski wrote:
[..]
> > Otherwise, without SO_PASSCGROUP, there is no way for datagram sockets
> > to find out the peer's open() time cgroup.
> 
> Right.
> 
> I'd still like to know what userspace applications want this feature.
> The canonical example seems to be journald, but journald doesn't use
> unix datagram sockets AFAICS,

Dan Walsh mentiond that systemd also monitors /dev/log (datagram socket) and
logs everything in journal. There this information should be useful.

Thanks
Vivek

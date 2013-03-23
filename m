Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CWVNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 17:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3CWVNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 17:13:12 -0400
Date: Sat, 23 Mar 2013 21:13:08 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] dm: dm-cache fails to write the cache device in
	writethrough mode
Message-ID: <20130323211308.GC30269@agk-dp.fab.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	device-mapper development <dm-devel@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joe Thornber <ejt@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org> <20130322223425.GA5638@redhat.com> <20130322231600.GD5357@blackbox.djwong.org> <20130323032715.GA7692@redhat.com> <20130323051549.GE5357@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323051549.GE5357@blackbox.djwong.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 10:15:49PM -0700, Darrick J. Wong wrote:
> Interesting ... if I set up this:
> # echo "0 67108864 linear /dev/sda 0" | dmsetup create origin
> And then repeat the test, but using /dev/mapper/origin as the origin instead
> of /dev/sda, the problem goes away.
 
So that looks like an easy and correct workaround for now.

Alasdair


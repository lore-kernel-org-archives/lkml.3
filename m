Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3FDL5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:57:35 -0400
Received: from mout.perfora.net ([74.208.4.194]:56196 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3FDL5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:57:32 -0400
Date: Tue, 4 Jun 2013 07:56:44 -0400
From: Jim Rees <rees@umich.edu>
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, viro@zeniv.linux.org.uk,
        matthew@wil.cx, dhowells@redhat.com, sage@inktank.com,
        smfrench@gmail.com, swhiteho@redhat.com, Trond.Myklebust@netapp.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        cluster-devel@redhat.com, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, piastryyy@gmail.com
Subject: Re: [PATCH v1 00/11] locks: scalability improvements for file locking
Message-ID: <20130604115644.GA4180@umich.edu>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
 <20130603213101.GC2109@fieldses.org>
 <20130604065417.46080a57@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604065417.46080a57@tlielax.poochiereds.net>
X-Provags-ID: V02:K0:XVft4ObdFYdY9/aw7zCbQFKwspfoAhI7uNxJ6ws7Jgm
 N0FMjCcDWsGlNFAdJN4/urwoAfmHDDW4OeKquEM1v/aMlq1bFY
 BRO9Rla1DWpk0+OM37y2hZLVcH2OpWQLNLV2GH3AkUM8Fk5lzY
 nrp60rgheXAwNQZpK4VFcYS1cbWgxTy5mJR+xYyePVlPg5Jrel
 m0MI29Ah6bHg9N3AQuRPbnTLhBP6c3BDond707BiKcwQa9s3+J
 nPlHSYKIga4SX+dAnimYdM1J/4t6S7CRAhFGEQQp7PMSZhMu60
 Ts8OaXn/Zz1dzISc+/8MUe7zHr4BDMbCfi20tCIUhO9qaNe+g=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:

  > Might be nice to look at some profiles to confirm all of that.  I'd also
  > be curious how much variation there was in the results above, as they're
  > pretty close.
  > 
  
  The above is just a random representative sample. The results are
  pretty close when running this test, but I can average up several runs
  and present the numbers. I plan to get a bare-metal test box on which
  to run some more detailed testing and maybe some profiling this week.

Just contributing more runs into the mean doesn't tell us anything about the
variance. With numbers that close you need the variance to tell whether it's
a significant change.

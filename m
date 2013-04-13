Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3DMQJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 12:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab3DMQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 12:09:29 -0400
Date: Sat, 13 Apr 2013 17:09:25 +0100
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Amit Kale <akale@stec-inc.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] bcache/dmcache/enhanceio bake-off
Message-ID: <20130413160925.GA5236@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Kent Overstreet <koverstreet@google.com>,
	Amit Kale <akale@stec-inc.com>, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130411072239.GD8910@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411072239.GD8910@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Thu, Apr 11, 2013 at 12:22:39AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Lately I've been having some fun playing with bcache, dmcache, and enhanceio.

I pushed some tweaks to the mq policy today to my thin-dev tree.  They
show some improvements to these fio based tests.

In addition I've written a blog post trying to explain what's going on in dm-cache:
http://device-mapper.org/blog/2013/04/13/benchmarking-dm-cache-with-fio/

- Joe

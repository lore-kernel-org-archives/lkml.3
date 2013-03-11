Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3CKX02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab3CKX00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:26:26 -0400
Date: Mon, 11 Mar 2013 19:26:15 -0400
From: Dave Jones <davej@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130311232615.GA28659@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311231227.GA319@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:12:27AM +0100, Markus Trippelsdorf wrote:
 > > I've started a full bisection from v3.8 to todays git tree. It will take
 > > ~13 steps. However it's already late here in Germany. I will continue
 > > the bisection tomorrow and report back.
 > 
 > The issue started with:
 > 
 > 74cd15cd02708c7188581f279f33a98b2ae8d322 is the first bad commit
 > commit 74cd15cd02708c7188581f279f33a98b2ae8d322
 > Author: Zheng Liu <wenqing.lz@taobao.com>
 > Date:   Mon Feb 18 00:32:55 2013 -0500
 > 
 >     ext4: reclaim extents from extent status tree
 > 
 > Please note that my local rtorrent version was configured with
 > "--with-posix-fallocate". I'm not sure if distributions also enable this
 > flag, but it could explain why Ted and Dave weren't able to reproduce
 > the problem so far.

Looks like Fedora doesn't, so indeed that could explain it.

	Dave


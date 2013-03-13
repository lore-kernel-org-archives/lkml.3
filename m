Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3CMKAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:00:12 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45614 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3CMKAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:00:09 -0400
Date: Wed, 13 Mar 2013 18:15:29 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130313101529.GA12012@gmail.com>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
References: <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
 <20130312033054.GB18595@thunk.org>
 <20130312061624.GA436@x4>
 <20130312064449.GA8806@gmail.com>
 <20130312064810.GA426@x4>
 <20130312071606.GA8900@gmail.com>
 <20130312132811.GI18595@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312132811.GI18595@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:28:11AM -0400, Theodore Ts'o wrote:
> On Tue, Mar 12, 2013 at 03:16:06PM +0800, Zheng Liu wrote:
> > 
> > Ted, I am wandering if we need to Cc this patch to stable kernel.  We
> > don't receive any report to complaint it, though, but it is worth
> > backporting it I think.
> 
> I'll check, bu I suspect it will require an explicit backport; it's
> not going to apply cleanly automatically, will it?  

I check the linux-stable tree and I think it can be applied cleanly from
3.0.y. because ext4_split_extent is introduced from 3.0 kernel.  So
maybe we can cc to stable@vger.kernel.org.  That would be great if you
could double check it.

Thanks,
                                                - Zheng

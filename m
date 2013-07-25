Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3GYUSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:18:50 -0400
Received: from longford.logfs.org ([213.229.74.203]:59916 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:18:47 -0400
Date: Thu, 25 Jul 2013 14:46:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Zach Brown <zab@redhat.com>
Cc: Dhaval Giani <dgiani@mozilla.com>, linux-kernel@vger.kernel.org,
        tytso@mit.edu, tglek@mozilla.com, vdjeric@mozilla.com,
        glandium@mozilla.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Message-ID: <20130725184647.GD15590@logfs.org>
References: <1374699833.7083.2.camel@localhost>
 <20130724233628.GD3641@logfs.org>
 <51F14136.30409@mozilla.com>
 <20130725180545.GB15590@logfs.org>
 <20130725200939.GH26554@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130725200939.GH26554@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 July 2013 13:09:39 -0700, Zach Brown wrote:
> 
> > > What about introducing a new flag, O_COMPR which tells the
> > > kernel, btw, we want this file to be decompressed if it can be. It
> > > can fallback to O_RDONLY or something like that? That gets rid of
> > > the chattr ugliness.
> > 
> > How is that different from chattr ugliness, which also comes down to a
> > single flag? ;)
> 
> It's much worse because it's per fd instead of per inode.
> 
> The page cache, where the undisclosed complexity of this proposal lurks,
> where compressed and uncompressed cached copies of the data need to be
> managed somehow, is per inode.

You've been giving it away!  Bad Zach, no cookies tonight.

Jörn

--
With a PC, I always felt limited by the software available. On Unix,
I am limited only by my knowledge.
-- Peter J. Schoenster

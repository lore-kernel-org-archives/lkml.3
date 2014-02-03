Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaBCVoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:44:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42494 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBCVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:43:58 -0500
Date: Mon, 3 Feb 2014 21:43:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203214354.GC10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
 <20140203211955.GY10323@ZenIV.linux.org.uk>
 <CA+55aFyfPVgGXn_hSBnnVyzWn4AbZQ40MPk_AoKB_6uC6LJqPg@mail.gmail.com>
 <20140203213926.GA10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203213926.GA10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 09:39:26PM +0000, Al Viro wrote:

> Which fs are you talking about?  For 9P it *is* a function of inode alone.
> For CIFS there's no wrong dentry to pick - it doesn't have links to start
> with.

Except that apparently it does ;-/  Bugger...

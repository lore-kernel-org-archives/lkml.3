Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3GSUCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3GSUCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:02:10 -0400
Date: Fri, 19 Jul 2013 16:01:58 -0400
From: Dave Jones <davej@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Message-ID: <20130719200158.GA19449@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719193106.GD5785@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719193106.GD5785@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:31:06PM -0700, Darrick J. Wong wrote:
 > On Fri, Jul 19, 2013 at 08:14:05PM +0800, Zheng Liu wrote:
 > > Hi Dave,
 > > 
 > > After applied this patch, the problem has been fixed in my own sand box.
 > > But that would be great if you could give it a try.  I want to make sure
 > > that this patch can fix the problem.  It looks like there has the same
 > > problem in ext3.  So if this patch is fine, I will generate a patch for
 > > ext3 file system.
 > 
 > Seems to fix the bug for me, both with your test case and also with trinity
 > runs, so...

Yeah, seems to be working here too. 

 > Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
 > Tested-by: Darrick J. Wong <darrick.wong@oracle.com>

likewise,

Tested-by: Dave Jones <davej@redhat.com>

	Dave

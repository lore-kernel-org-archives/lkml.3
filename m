Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab3BLO13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382Ab3BLO12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:27:28 -0500
Date: Tue, 12 Feb 2013 09:27:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ima: Do not try to fix hash if file system does not
 support security xattr
Message-ID: <20130212142704.GB23410@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-2-git-send-email-vgoyal@redhat.com>
 <1360669506.3524.233.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360669506.3524.233.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 06:45:06AM -0500, Mimi Zohar wrote:
> On Mon, 2013-02-11 at 15:11 -0500, Vivek Goyal wrote:
> > vfs_getxattr_alloc() returns -EOPNOTSUPP if filesystem does not have
> > security label enabled. In that case there is no point in continuing
> > further and try to fix hashes (if ima_appraise=fix was specified) as
> > that will fail too. Return early
> 
> There's a minor discrepancy between the patch title and the patch
> description - not supported vs. not enabled.  Perhaps the title could be
> abbreviated as well to something like "ima: detect security xattrs not
> enabled".

Sure will change it.

Thanks
Vivek

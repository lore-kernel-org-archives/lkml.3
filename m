Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3JVX6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:58:33 -0400
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:35107 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752534Ab3JVX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:58:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:968:
X-HE-Tag: base05_2c95c07167846
X-Filterd-Recvd-Size: 1683
Message-ID: <1382486304.2041.103.camel@joe-AO722>
Subject: Re: [PATCH 00/24] treewide: Convert use of typedef ctl_table to
 struct ctl_table
From: Joe Perches <joe@perches.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, codalist@TELEMANN.coda.cs.cmu.edu,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, keyrings@linux-nfs.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org
Date: Tue, 22 Oct 2013 16:58:24 -0700
In-Reply-To: <52670FF4.8070701@gmail.com>
References: <cover.1382480758.git.joe@perches.com>
	 <52670FF4.8070701@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 16:53 -0700, David Daney wrote:
> After all this work, why not go ahead and remove the typedef?  That way 
> people won't add more users of this abomination.

Hi David.

The typedef can't be removed until all the uses are gone.

I've sent this before as a single large patch as well as
individual patches.

treewide:	https://lkml.org/lkml/2013/7/22/600
RemoveTypedef:	https://lkml.org/lkml/2013/7/22/603


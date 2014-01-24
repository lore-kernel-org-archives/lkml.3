Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaAXCWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:22:46 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43731 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbaAXCWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:22:44 -0500
Message-ID: <1390530162.15909.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: manual merge of the scsi tree with Linus' tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Stephen M.Cameron" <scameron@beardog.cce.hp.com>
Date: Thu, 23 Jan 2014 18:22:42 -0800
In-Reply-To: <20140124130547.323ce38edc8dedfd653534b7@canb.auug.org.au>
References: <20140124130547.323ce38edc8dedfd653534b7@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 13:05 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next merge of the scsi tree got conflicts in
> drivers/scsi/hpsa.c and drivers/scsi/hpsa.h between commits from Linus'
> tree and commits from the scsi tree.
> 
> This has happened because what you submitted to Linus differed
> significantly to what is in the scsi tree in linux-next.  :-(
> 
> I have just dropped the scsi tree for now.

Hm, sorry about that.  It looks like there was a failed push of the
for-next branch five weeks ago when I rebased to drop a pm80xx commit.
This also caused it to be six commits behind (five hpsa and one ipr)
because they were added after the rebase.

Not sure what else to do except "will try harder in future".

James



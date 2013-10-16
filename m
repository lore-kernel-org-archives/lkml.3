Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465Ab3JPTWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:22:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35110 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761288Ab3JPTWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:22:17 -0400
Message-ID: <1381929897.1864.0.camel@dabdike>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: dgilbert@interlog.com
Cc: vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>,
        linux-kernel@vger.kernel.org,
        SCSI development list <linux-scsi@vger.kernel.org>
In-Reply-To: <52540C7F.8050207@interlog.com>
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com>
	 <5253A9E7.5030707@oracle.com> <52540C7F.8050207@interlog.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Oct 2013 14:24:57 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 09:45 -0400, Douglas Gilbert wrote:
> On 13-10-08 02:44 AM, vaughan wrote:
> > Hi Madper,
> >
> > CC to Douglas to get comments.
> > I use the rw_semaphore o_sem to protect excl open, introduced in commit
> > 15b06f9a02406e5460001db6d5af5c738cd3d4e7 since v3.12-rc1.
> > Is it forbidden to do like that in kernel?...
> 
> It appears you can not (allow sg_open() to hold a semaphore
> then return to the user space). So you will need to do some
> rework on that patch or revert it.

OK, there being no reply on this, I'll do the revert ... that's all four
patches, correct?

James



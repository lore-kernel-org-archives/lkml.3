Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3F0GOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:14:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42327 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab3F0GOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:14:05 -0400
Message-ID: <1372313642.557.19.camel@dabdike>
Subject: Re: fcoe pull request for 3.9-rc
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 26 Jun 2013 23:14:02 -0700
In-Reply-To: <51CA03C1.1040901@intel.com>
References: <51CA03C1.1040901@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 20:55 +0000, Love, Robert W wrote:
> The following changes since commit 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82:
> 
>    Merge branch 'for-linus' of 
> git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-06-25 
> 09:08:07 -1000)
> 
> are available in the git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
> tags/critical_fix_for_3.9

This is simple and I can review from the attached patch, so I'll take it
this time. But, please, next time follow proper process.  That means the
individual patches should go over the SCSI mailing list for review
*before* they're sent in a pull request.

James



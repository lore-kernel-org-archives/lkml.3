Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3ELRVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 13:21:55 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:46740 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3ELRVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 13:21:54 -0400
Message-ID: <518FCFAC.8030306@redhat.com>
Date: Sun, 12 May 2013 19:21:48 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.9+ merge window
References: <1368226800.2024.32.camel@dabdike>
In-Reply-To: <1368226800.2024.32.camel@dabdike>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/05/2013 01:00, James Bottomley ha scritto:
> This is the final round of SCSI patches for the merge window.  It
> consists mostly of driver updates (bnx2fc, ibmfc, fnic, lpfc, be2iscsi,
> pm80xx, qla4x and ipr).  There's also the power management updates that
> complete the patches in Jens' tree, an iscsi refcounting problem fix
> from the last pull, some dif handling in scsi_debug fixes, a few nice
> code cleanups and an error handling busy bug fix.
> 

James,

can I have an answer about who is going to apply
http://thread.gmane.org/gmane.linux.kernel/1436904?  It is both a bugfix
and a minor security fix, has an Acked-by from Tejun, and has otherwise
been sitting there for almost three months.

Paolo


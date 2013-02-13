Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab3BMADS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:03:18 -0500
Received: from mail.avalus.com ([89.16.176.221]:59489 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab3BMADR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:03:17 -0500
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Alex Bligh <alex@alex.org.uk>
In-Reply-To: <20130212133207.ef6b24f5.akpm@linux-foundation.org>
Date: Wed, 13 Feb 2013 00:03:06 +0000
Cc: Alex Bligh <alex@alex.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com> <20130212133207.ef6b24f5.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12 Feb 2013, at 21:32, Andrew Morton wrote:

> 
> Obviously the changelog was inadequate.  Please send along a new one
> which fully describes the reasons for this change.

To be clear I have no complaints about the rest of the patch being
merged. Supporting FLUSH but not FUA is far better than supporting
neither. I just didn't understand dropping FUA given the semantics
of nbd is in essence 'linux bios over tcp'.

-- 
Alex Bligh





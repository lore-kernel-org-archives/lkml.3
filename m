Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab3BMRf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:35:59 -0500
Received: from mail.avalus.com ([89.16.176.221]:49233 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab3BMRf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:35:58 -0500
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Alex Bligh <alex@alex.org.uk>
In-Reply-To: <511BB902.3080302@redhat.com>
Date: Wed, 13 Feb 2013 17:35:56 +0000
Cc: Alex Bligh <alex@alex.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>
Content-Transfer-Encoding: 7bit
Message-Id: <4CB78CEB-E66C-4C88-BF0D-26EECE13CAC6@alex.org.uk>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com> <20130212133207.ef6b24f5.akpm@linux-foundation.org> <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk> <511B8E65.5020507@redhat.com> <3EDEF735-9A67-439E-BA65-089C6AAFD1BF@alex.org.uk> <511BB902.3080302@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13 Feb 2013, at 16:02, Paolo Bonzini wrote:

> If you do not have REQ_FUA, as is the case with this patch, the block
> layer converts it to a REQ_FLUSH *after* the write.

OK. Well +/- it converting an fdatasync() into a full fsync(), that
should be be ok.

-- 
Alex Bligh





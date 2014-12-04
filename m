Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaLDVBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:01:18 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57866 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbaLDVBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:01:14 -0500
Date: Thu, 4 Dec 2014 16:01:10 -0500
From: Tejun Heo <tj@kernel.org>
To: nick <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Another FIXME in libata-scsi.c
Message-ID: <20141204210110.GF4080@htj.dyndns.org>
References: <547FDDFF.7050802@gmail.com>
 <20141204182326.GC4080@htj.dyndns.org>
 <5480CAEF.8030500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480CAEF.8030500@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 03:58:23PM -0500, nick wrote:
> Are you sure as it seems FIX MES mean unfinished work and issues. I
> would personally remove the FIX ME part at least.

It really doesn't matter unless it's actively misleading.  If you have
good enough justification that the comment is unnecessary /
misleading, please feel free to submit a patch with accompanying
rationales but it's not something we should spend time and energy
collaborating on.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaIMEoC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 00:44:02 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33997 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaIMEoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 00:44:00 -0400
Date: Sat, 13 Sep 2014 13:43:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2] AHCI: Optimize interrupt processing
Message-ID: <20140913044351.GA30477@mtj.dyndns.org>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20140911124248.GA18490@dhcp-27-160.brq.redhat.com>
 <20140911124437.GB18490@dhcp-27-160.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911124437.GB18490@dhcp-27-160.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:44:37PM +0200, Alexander Gordeev wrote:
> Split interrupt service routine into hardware context handler and
> threaded context handler. That allows to protect ports with individual
> locks rather than with a single host-wide lock, which results in better
> parallelism.

This patch is way too large.  Can you please split it up to smaller
logical changes?

Thanks.

-- 
tejun

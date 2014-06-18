Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaFRSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:16:26 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49012 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaFRSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:16:24 -0400
Date: Wed, 18 Jun 2014 14:16:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
Message-ID: <20140618181620.GB11042@htj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
 <1402590209-31610-6-git-send-email-tj@kernel.org>
 <alpine.DEB.2.10.1406131215330.1717@gentwo.org>
 <20140613182538.GB3723@htj.dyndns.org>
 <alpine.DEB.2.11.1406131354210.24349@gentwo.org>
 <alpine.DEB.2.11.1406161029250.20878@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406161029250.20878@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Jun 16, 2014 at 10:31:26AM -0500, Christoph Lameter wrote:
> Just went through it. About 30 patches still left. Some of the subsystems
> that indicated acceptance did not merge the patches. Guess I will patch
> the whole thing and make my rounds again. Or could we get this through the
> percpu tree?

If the maintainers agree (or nobody cares), sure.

Thanks.

-- 
tejun

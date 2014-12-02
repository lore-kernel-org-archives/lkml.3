Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaLBRoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:44:32 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:42072 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:44:30 -0500
Date: Tue, 2 Dec 2014 12:44:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.18-fixes] s390: fix machine check regression
 caused by the conversion from __get_cpu_var() to this_cpu_ptr()
Message-ID: <20141202174427.GF10918@htj.dyndns.org>
References: <alpine.LFD.2.11.1411281544190.1648@denkbrett>
 <20141202171911.GD10918@htj.dyndns.org>
 <alpine.LFD.2.11.1412021829260.1611@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1412021829260.1611@denkbrett>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 06:32:28PM +0100, Sebastian Ott wrote:
> On Tue, 2 Dec 2014, Tejun Heo wrote:
> > Sorry about the delay.  Was on vacation.
> > 
> > Patch applied to percpu/for-3.18-fixes w/ minor updates to the patch
> > subject and description.  Will push out to Linus soon.
> > 
> 
> I've seen that Martin took the patch and it's already in Linus' tree -
> commit 2cb4a18262fd0108cb8abd875710c59d0aa66f1d

Ah, okay.  Dropping from percpu/for-3.18-fixes then.

Thanks.

-- 
tejun

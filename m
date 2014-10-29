Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbaJ2PTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:19:45 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35067 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaJ2PTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:19:44 -0400
Date: Wed, 29 Oct 2014 11:19:28 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [percpu] Convert remaining __get_cpu_var uses in 3.18-rcX
Message-ID: <20141029151928.GE25226@htj.dyndns.org>
References: <alpine.DEB.2.11.1410271047400.17089@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410271047400.17089@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:49:45AM -0500, Christoph Lameter wrote:
> During the 3.18 merge period additional __get_cpu_var uses were
> added. The patch converts these to this_cpu_ptr().
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.19.

Thanks.

-- 
tejun

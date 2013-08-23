Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3HWUJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:09:55 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41930 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3HWUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:09:53 -0400
Date: Fri, 23 Aug 2013 16:09:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv 02/16] percpu: Make __verify_pcu_ptr handle per cpu
 pointers to arrays
Message-ID: <20130823200947.GB11391@mtj.dyndns.org>
References: <20130823190135.726207430@linux.com>
 <00000140ac8deda6-09306a6b-8b41-48f6-8d72-5f9154593832-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ac8deda6-09306a6b-8b41-48f6-8d72-5f9154593832-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:01:58PM +0000, Christoph Lameter wrote:
> __verify_pcpu_ptr() will cause a compilation failure if the type of the
> pointer is a pointer to a fixed array of objects. Adding zero to the
> pointer converts the type of pointer to that pointing to a single
> object of the array.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.12.

Thanks.

-- 
tejun

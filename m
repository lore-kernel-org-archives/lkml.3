Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaJ0PH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:07:58 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58513 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaJ0PH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:07:57 -0400
Date: Mon, 27 Oct 2014 11:07:52 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20141027150752.GQ4436@htj.dyndns.org>
References: <alpine.DEB.2.11.1410150308150.20152@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410150308150.20152@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Wed, Oct 15, 2014 at 03:10:37AM -0500, Christoph Lameter wrote:
> Subject: Convert remaining __get_cpu_var uses
> 
> During the 3.18 merge period additional __get_cpu_var uses were
> added. The patch converts these to this_cpu_ptr().
> 
> [This does not address the powerpc issue where the conversion
> patches were routed directly to the powerpc maintainers but were
> not applied in the merge period. Will have to be handled separately]
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Can you please repost with proper subject line and the subsys
maintainers cc'd?

Thanks.

-- 
tejun

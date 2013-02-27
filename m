Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3B0Cat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:30:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3B0Car (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:30:47 -0500
Message-ID: <512D6FD4.8040508@wwwdotorg.org>
Date: Tue, 26 Feb 2013 19:30:44 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Imre Deak <imre.deak@intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v5] lib/scatterlist: use page iterator in the mapping
 iterator
References: <1361455080-23667-1-git-send-email-imre.deak@intel.com> <1361703937-1212-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1361703937-1212-1-git-send-email-imre.deak@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 04:05 AM, Imre Deak wrote:
> For better code reuse use the newly added page iterator to iterate through
> the pages.  The offset, length within the page is still calculated by the
> mapping iterator as well as the actual mapping.  Idea from Tejun Heo.

Just for completeness, this updated combined patch,
Tested-by: Stephen Warren <swarren@wwwdotorg.org>

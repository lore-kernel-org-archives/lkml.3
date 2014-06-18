Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965531AbaFRJGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:06:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964920AbaFRJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:06:18 -0400
Date: Wed, 18 Jun 2014 10:06:16 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>
Subject: Re: [PATCH] extcon: Remove unnecessary OOM messages
Message-ID: <20140618090615.GA3412@opensource.wolfsonmicro.com>
References: <000401cf8ab6$6613d350$323b79f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401cf8ab6$6613d350$323b79f0$%han@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:30:21PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message. The following
> checkpatch warning is also removed.
> 
>   WARNING: Possible unnecessary 'out of memory' message
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

For the Arizona bit:

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles

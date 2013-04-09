Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935059Ab3DIM6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:58:39 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48295
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172Ab3DIM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:58:38 -0400
Date: Tue, 9 Apr 2013 14:58:17 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: rob@landley.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH] Documentation: cfq-iosched: update documentation help
 for cfq tunnables
Message-ID: <20130409125817.GC12244@kernel.dk>
References: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31 2013, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add the documentation text for latency, target_latency & group_idle
> tunnable parameters in the block/cfq-iosched.txt.
> Also fix few typo(spelling) mistakes.

Thanks, merged with various fixups to the language. You can see the end-result
here:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=fdc6fdc52e4630f5020281ce5450be7cc1887de2

-- 
Jens Axboe


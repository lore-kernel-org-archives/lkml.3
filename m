Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3DNIPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 04:15:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48125 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3DNIPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 04:15:52 -0400
Date: Sun, 14 Apr 2013 10:15:21 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Rob Landley <rob@landley.net>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH] Documentation: cfq-iosched: update documentation help
 for cfq tunnables
Message-ID: <20130414081521.GC12244@kernel.dk>
References: <1364698505-22236-1-git-send-email-linkinjeon@gmail.com>
 <1365873934.18069.96@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365873934.18069.96@driftwood>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13 2013, Rob Landley wrote:
> Cleaning out "look at this" directory, I don't see this applied upstream but
> it may already be in Jens' tree. (That's the tree it should go in
> through...)

It's already included, see:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=fdc6fdc52e4630f5020281ce5450be7cc1887de2

I changed some of the wording. But since this is your forte, please do
send any incremental patches against what is already in there.

-- 
Jens Axboe


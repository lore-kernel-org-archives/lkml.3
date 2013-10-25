Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3JYPGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:06:16 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45373 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753474Ab3JYPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:06:14 -0400
Date: Fri, 25 Oct 2013 10:06:09 -0500
From: Ben Myers <bpm@sgi.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH v2] xfs:xfs_dir2_node.c: pointer use before check for
 null
Message-ID: <20131025150609.GB10553@sgi.com>
References: <20131022203322.GA2797@dastard>
 <1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 03:53:25PM +0400, Denis Efremov wrote:
> ASSERT on args takes place after args dereference.
> This assertion is redundant since we are going to panic anyway.
> 
> Found by Linux Driver Verification project (linuxtesting.org) -
> PVS-Studio analyzer.
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Looks good. 

Reviewed-by: Ben Myers <bpm@sgi.com>

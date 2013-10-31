Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3JaP4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:56:07 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50584 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753486Ab3JaP4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:56:06 -0400
Date: Thu, 31 Oct 2013 10:56:03 -0500
From: Ben Myers <bpm@sgi.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: ldv-project@linuxtesting.org, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs:xfs_dir2_node.c: pointer use before check for
 null
Message-ID: <20131031155602.GP1935@sgi.com>
References: <20131022203322.GA2797@dastard>
 <1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
 <20131025150609.GB10553@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025150609.GB10553@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 10:06:09AM -0500, Ben Myers wrote:
> On Fri, Oct 25, 2013 at 03:53:25PM +0400, Denis Efremov wrote:
> > ASSERT on args takes place after args dereference.
> > This assertion is redundant since we are going to panic anyway.
> > 
> > Found by Linux Driver Verification project (linuxtesting.org) -
> > PVS-Studio analyzer.
> > 
> > Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> 
> Looks good. 
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks Denis.

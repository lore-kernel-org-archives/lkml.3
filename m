Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCFTWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:22:03 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:43326 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaCFTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:22:00 -0500
Date: Thu, 6 Mar 2014 14:21:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 2/5][RFC][CFT] fold pcpu_split_block() into the only
 caller
Message-ID: <20140306192156.GB14033@htj.dyndns.org>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305035009.GB26528@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305035009.GB26528@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 03:50:10AM +0000, Al Viro wrote:
> ... and clean it up a bit
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Oh, you're collapsing pcpu_split_block() here.  Please disregard the
review about the function comment and @size in the previous patch
then.

Thanks.

-- 
tejun

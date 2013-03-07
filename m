Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709Ab3CGSsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:48:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58748 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755969Ab3CGSsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:48:01 -0500
Date: Thu, 7 Mar 2013 12:48:00 -0600
From: Ben Myers <bpm@sgi.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH -v3 12/23] xfs: rename random32() to prandom_u32()
Message-ID: <20130307184800.GW30652@sgi.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
 <1362401911-14074-13-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362401911-14074-13-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu,

On Mon, Mar 04, 2013 at 09:58:20PM +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: <bpm@sgi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

Applied this to git://oss.sgi.com/xfs/xfs.git, master branch.

Thanks!
-Ben

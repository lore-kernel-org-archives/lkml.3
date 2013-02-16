Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3BPIGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:06:10 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:15108 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812Ab3BPIGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:06:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmUJAN88H1F5LO+j/2dsb2JhbABEhWC1KYURexdzgh8BAQU6HCMQCAMYCSUPBSUDIROIEQ28eBWOSA8/B4NAA5YngR6IO4Z9gVKBSQ
Date: Sat, 16 Feb 2013 19:06:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, CAI Qian <caiqian@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [ 01/10] Revert: xfs: fix _xfs_buf_find oops on blocks beyond
 the filesystem end
Message-ID: <20130216080604.GX26694@dastard>
References: <20130215225543.586012193@linuxfoundation.org>
 <20130215225543.743915307@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215225543.743915307@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 02:56:33PM -0800, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> This reverts commit a56040731e5b00081c6d6c26b99e6e257a5d63d7 which was
> commit eb178619f930fa2ba2348de332a1ff1c66a31424 upstream.
> 
> It has been reported to cause problems:
> 	http://bugzilla.redhat.com/show_bug.cgi?id=909602
> 
> Acked-by: Ben Myers <bpm@sgi.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: CAI Qian <caiqian@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

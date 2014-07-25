Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaGYBSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:18:33 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19238 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbaGYBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:18:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQMAHOv0VN5LHOdPGdsb2JhbABZgw6BKYInhQioJgEBAgIGoSkBgRAXBQEBAQE4NoQEAQU6HCMQCAMYCSUPBSUDBxoTiEG/bBcYhWOJUAeDLoEYBZs1mCArLw
Date: Fri, 25 Jul 2014 11:17:48 +1000
From: Dave Chinner <david@fromorbit.com>
To: yuanh <yuanhp_china@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux fsync behaviour
Message-ID: <20140725011748.GB26465@dastard>
References: <1406241691732-911707.post@n7.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406241691732-911707.post@n7.nabble.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:41:31PM -0700, yuanh wrote:
> Hi all,
> 
>    Two file descriptors are pointing the same file. When fsync is called on
> one fd, the data written by the other fd will also be flushed? We are using
> linux XFS.

Yes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

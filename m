Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbbA1CZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:25:05 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45175 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934257AbbA1CZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:25:00 -0500
Date: Tue, 27 Jan 2015 21:24:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3.18 11/61] workqueue: fix subtle pool management issue
 which can stall whole worker_pool
Message-ID: <20150128022456.GF12314@htj.dyndns.org>
References: <20150128012636.936333725@linuxfoundation.org>
 <20150128012638.187292688@linuxfoundation.org>
 <54C840BA.7020207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C840BA.7020207@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:51:54AM +0800, Lai Jiangshan wrote:
> On 01/28/2015 09:26 AM, Greg Kroah-Hartman wrote:
> > 3.18-stable review patch.  If anyone has any objections, please let me know.
> 
> 
> I don't think it is a bug-fix.
> It is just a good cleanup.

It is a bug fix, for a rare but potentially critical issue.  Please
read the patch description.  It contains ample information on what's
broken and also the link to the original bug report.

Thanks.

-- 
tejun

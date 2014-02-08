Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBHPJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:09:01 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:37442 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaBHPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:08:59 -0500
Date: Sat, 8 Feb 2014 10:08:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 driver-core-next] kernfs: prepare for cgroup's
 kernfs conversion
Message-ID: <20140208150856.GB3263@htj.dyndns.org>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
 <20140207184320.GD12815@htj.dyndns.org>
 <20140208001254.GA31648@kroah.com>
 <20140208150751.GA3263@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208150751.GA3263@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 10:07:51AM -0500, Tejun Heo wrote:
> On Fri, Feb 07, 2014 at 04:12:54PM -0800, Greg KH wrote:
> > Ok, I should have now applied all of these, and hopefully in the correct
> > order.  If I got anything wrong, please let me know.
> 
> Everything looks good to me.

Ooh, JFYI, I'm pulling driver-core-next into cgroup for-3.15 so that
cgroup kernfs conversion can be put on top of it.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3J3OrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:47:03 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:58182 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3J3OrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:47:01 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2013 10:47:01 EDT
Date: Wed, 30 Oct 2013 10:41:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs,
 part #1
Message-ID: <20131030144132.GD27632@htj.dyndns.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
 <20131029222950.GA9612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029222950.GA9612@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Tue, Oct 29, 2013 at 03:29:50PM -0700, Greg KH wrote:
> I've applied the first 6 patches here, as they only did cleanup stuff.
> As it's late in the development cycle (i.e. 3.12 is going to be out in
> days), I'd prefer to wait on the rest until 3.13-rc1 is out so that it
> gets lots of testing in linux-next.
> 
> So, I'll hold off on the rest of these until then, ok?

Yeah, sounds good to me.  kernfs isn't functional yet anyway and there
will be more sweeping changes so it probably is the least painful if
we do all the big changes in one cycle anyway.

Thanks.

-- 
tejun

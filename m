Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3JCQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:25:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3JCQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:25:23 -0400
Date: Thu, 3 Oct 2013 09:25:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131003162519.GA25042@kroah.com>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
 <20131003152715.GA15931@kroah.com>
 <B674A07C-F8FE-4F4D-BB0A-87D5A50852D0@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B674A07C-F8FE-4F4D-BB0A-87D5A50852D0@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:21:10AM -0500, Kumar Gala wrote:
> 
> On Oct 3, 2013, at 10:27 AM, Greg Kroah-Hartman wrote:
> 
> > On Thu, Oct 03, 2013 at 09:45:38AM -0500, Kumar Gala wrote:
> >> As we look at upstreaming more support for the Qualcomm MSM SoCs there
> >> are a number of drivers or library like routines that are unique to
> >> the MSM platform, we are thinking that putting them under:
> >> 
> >> drivers/platform/qcom/
> > 
> > What type of drivers are these?  Shouldn't they really go under the
> > specific driver type directory instead?
> 
> If there isn't an existing driver/ dir for this I dont see how it can go there, I'm not also not really a fan of trying to artificial put something that is highly SoC specific into something generic of this nature.

Loose a line-wrap somewhere?...

Anyway, you didn't answer my question, so why do I need to answer yours?

snarkily,

greg k-h

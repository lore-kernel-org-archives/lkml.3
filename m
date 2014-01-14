Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaANQdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:33:20 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42970 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaANQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:33:17 -0500
Date: Tue, 14 Jan 2014 17:33:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: atomlin@redhat.com, linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/2] hung_task: Display every hung task warning
Message-ID: <20140114163314.GE31734@gmail.com>
References: <1389633292-23588-1-git-send-email-atomlin@redhat.com>
 <1389633292-23588-3-git-send-email-atomlin@redhat.com>
 <52D545F7.2020503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D545F7.2020503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 01/13/2014 12:14 PM, atomlin@redhat.com wrote:
> > From: Aaron Tomlin <atomlin@redhat.com>
> > 
> > Enable hung_task_warnings to display every hung
> > task warning when set to -1.
> > 
> > Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> 
> Aaron and I talked on IRC, and after some talking these patches
> now make sense to me :)
> 
> The kernel apparently limits how many hung task warnings it
> will display at a time, when a timeout occurs.  Aaron's patch
> allows that limit to be set to "unlimited", which will cause
> the kernel to display info about all hung tasks.

The changelog needs to be updated with such kind of descriptive 
information.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3AKTJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:09:08 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3AKTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:09:05 -0500
Date: Fri, 11 Jan 2013 13:09:00 -0600
From: Ben Myers <bpm@sgi.com>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] fs/xfs remove obsolete simple_strto<foo>
Message-ID: <20130111190900.GA27055@sgi.com>
References: <1357740282-2377-1-git-send-email-abhi.c.pawar@gmail.com>
 <50EFB2FE.2000307@oracle.com>
 <50EFC356.10908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EFC356.10908@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jan 11, 2013 at 01:16:30PM +0530, Abhijit Pawar wrote:
> On 01/11/2013 12:06 PM, Jeff Liu wrote:
> > On 01/09/2013 10:04 PM, Abhijit Pawar wrote:
> >> This patch replaces usages of obsolete simple_strtoul with kstrtoint in xfs_args and suffix_strtoul.
> >>
> >> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
> > checkpatch.pl show warning if we return EINVAL as below:
> > WARNING: return of an errno should typically be -ve (return -EINVAL)
> > 
> > Can we just ignore such code style issue?
> I think we can.
> Ben?

Yep, no worries.

Regards,
	Ben

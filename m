Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3CABm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:42:26 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58741 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3CABmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:42:24 -0500
Message-ID: <1362102139.9158.30.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 28 Feb 2013 20:42:19 -0500
In-Reply-To: <20130228205735.GE11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <20130228185155.GC11360@redhat.com>
	 <1362083401.2908.412.camel@falcor1.watson.ibm.com>
	 <20130228205735.GE11360@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030101-7282-0000-0000-000014C11703
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 15:57 -0500, Vivek Goyal wrote:
> Hi Mimi,
> 
> You asked me to not come up with new signing scheme and look into IMA
> and make use of it. And that's what I am trying to do. As I continue
> to do implementation, new concerns crop up and I am raising these.

And I appreciate it.  As can be seen by the number of use cases already
supported by the integrity subsystem, it doesn't make sense for each
case to hash the file independently.

You've brought up some valid issues, which I'm trying to help you
address, but instead of working them through, your emails basically end
by saying "how is IMA going to deal with it" or "it's impossible".
Instead lets try to find viable solutions.

thanks,

Mimi


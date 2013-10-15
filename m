Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab3JOQ4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:56:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46161 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200Ab3JOQ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:56:19 -0400
Date: Tue, 15 Oct 2013 18:56:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Joe Perches <joe@perches.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
Message-ID: <20131015165605.GE7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
 <20131011160208.GL5925@pd.tnic>
 <20131014045500.GC12189@gchen.bj.intel.com>
 <20131014103616.GE4009@pd.tnic>
 <CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
 <525D2A07.6080201@linux.vnet.ibm.com>
 <20131015122958.GD7908@pd.tnic>
 <1381855341.22110.21.camel@joe-AO722>
 <CA+8MBb+jbsTupiDL-kKQDwwnpck0wDk8Y-ZnLRuBeZWrvM-LAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBb+jbsTupiDL-kKQDwwnpck0wDk8Y-ZnLRuBeZWrvM-LAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:49:06AM -0700, Tony Luck wrote:
> On Tue, Oct 15, 2013 at 9:42 AM, Joe Perches <joe@perches.com> wrote:
> > No guarantees are made about dmesg output.
> 
> I'm with Joe here.  Current users that parse dmesg have grumbled a bit
> that format changes - but they know that's the way life is.  Perhaps they'll
> be too busy cheering about the TRACE formats that we are going to give
> them that they won't whine too much about this.

Ok, I'll make sure to forward all complaints to you and Joe then. :)

In any case, we talked about it, you think it is not worth preserving
it, we can drop the printks and see who cries out.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3JOQtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:49:15 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45060 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3JOQtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <1381855341.22110.21.camel@joe-AO722>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
	<20131011160208.GL5925@pd.tnic>
	<20131014045500.GC12189@gchen.bj.intel.com>
	<20131014103616.GE4009@pd.tnic>
	<CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
	<525D2A07.6080201@linux.vnet.ibm.com>
	<20131015122958.GD7908@pd.tnic>
	<1381855341.22110.21.camel@joe-AO722>
Date: Tue, 15 Oct 2013 09:49:06 -0700
Message-ID: <CA+8MBb+jbsTupiDL-kKQDwwnpck0wDk8Y-ZnLRuBeZWrvM-LAg@mail.gmail.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output format
From: Tony Luck <tony.luck@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 9:42 AM, Joe Perches <joe@perches.com> wrote:
> No guarantees are made about dmesg output.

I'm with Joe here.  Current users that parse dmesg have grumbled a bit
that format changes - but they know that's the way life is.  Perhaps they'll
be too busy cheering about the TRACE formats that we are going to give
them that they won't whine too much about this.

-Tony

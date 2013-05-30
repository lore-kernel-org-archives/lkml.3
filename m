Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3E3NhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:37:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3E3NhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:37:12 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UyY1rksVWFoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dy2dsGysKfcA:10 a=kXRgH0KGbQJbFpd9bFgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369921028.26799.4.camel@gandalf.local.home>
Subject: Re: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Ortiz, Lance E" <lance.oritz@hp.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 May 2013 09:37:08 -0400
In-Reply-To: <20130530072849.GA20793@pd.tnic>
References: <20130529190326.24171.86905.stgit@grignak.americas.hpqcorp.net>
	 <30463843.EmBn1xaq3I@vostro.rjw.lan>
	 <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
	 <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
	 <20130530072849.GA20793@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 09:28 +0200, Borislav Petkov wrote:
> On Thu, May 30, 2013 at 04:55:20AM +0000, Ortiz, Lance E wrote:
> > This TODO is a note for future clean-up and is not directly related to
> >the bug being fixed with this patch. Which lends to the argument of why
> >put the TODO in this patch? Opportunistic. I don’t think we want to
> >create a separate patch just for a TODO note.
> 
> Sounds to me, this TODO item should be on your TODO list - not in kernel
> sources :-)
> 

Also, that TODO sounds like there's output to userspace that can be
parsed by a userspace tool. If a tool expects the current format, it may
not be acceptable to change it later.

If the contents of this patch has nothing to do with the TODO, then
leave it out. It just confuses things.

-- Steve



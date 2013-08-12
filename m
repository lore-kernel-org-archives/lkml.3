Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3HLNNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:13:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab3HLNNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:13:39 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=tvvMzHJ_TWIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XlcgNrZLg9MA:10 a=VnNF1IyMAAAA:8 a=tVso5knitFx3NTrJDhUA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 09:13:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com, rjw@sisk.pl,
        lance.ortiz@hp.com, m.chehab@samsung.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mce: acpi/apei: trace: Include PCIe AER trace event
 conditionally
Message-ID: <20130812091337.6f8c057d@gandalf.local.home>
In-Reply-To: <5208C8DD.3050204@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
	<1375986471-27113-2-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
	<20130808152329.1f98b5e0@gandalf.local.home>
	<5208C8DD.3050204@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 17:07:01 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:

> > TRACE_EVENT_PCIE_AER for the users as well. That is, the places that
> > include ras.h and use the trace_aer_*() tracepoints.
> 
> Do you mean the change I've done to aerdrv-errprint.c below? This trace 
> point is currently only used there, so I guess we are ok?
> 


Yeah, if it's only used on one place, then it's fine. But if it gets
used in other files, than those other files with have to define the
macro as well.

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3FFUBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:01:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3FFUBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:01:02 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MWvAT0ojoM8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=NT8Ab2geWARtfnoThroA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370548859.9844.41.camel@gandalf.local.home>
Subject: Re: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@elte.hu, bp@alien8.de, linux-edac@vger.kernel.org,
        tony.luck@intel.com, dle-develop@lists.sourceforge.net,
        tomoki.sekiyama@hds.com
Date: Thu, 06 Jun 2013 16:00:59 -0400
In-Reply-To: <1370546299.9844.40.camel@gandalf.local.home>
References: <51B0A90F.7030309@hds.com> <51B0A9B4.4080703@hds.com>
	 <1370546299.9844.40.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 15:18 -0400, Steven Rostedt wrote:
> On Thu, 2013-06-06 at 11:24 -0400, Seiji Aguchi wrote:

> Since we are basically down to cosmetic changes, can you make the
> renames of these variables into a separate patch. As they are now more
> about the debug IDT than a NMI idt, it should have been done before, and
> is a separate change to what you are doing here.

I would even add the is_debug_idt_enabled() and load_debug_idt()
interface to that patch as well.

-- Steve



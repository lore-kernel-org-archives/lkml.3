Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3FFVCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:02:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3FFVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:02:18 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MWvAT0ojoM8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=cZp-jb_gqwpYs19iVgcA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370552535.9844.49.camel@gandalf.local.home>
Subject: Re: [PATCH v14 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date: Thu, 06 Jun 2013 17:02:15 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03198C@USINDEM103.corp.hds.com>
References: <51B0A90F.7030309@hds.com> <51B0A9B4.4080703@hds.com>
	 <1370546299.9844.40.camel@gandalf.local.home>
	 <1370548859.9844.41.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41B03198C@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 20:52 +0000, Seiji Aguchi wrote:
> Steven,
> 
> Thank you for reviewing.
> 
> I will create a patch just renaming variables and adding the is_debug_idt_enabled() and load_debug_idt().
> 

Thanks, and you can have the code use those functions as well.

-- Steve



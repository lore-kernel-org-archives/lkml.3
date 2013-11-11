Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3KKQCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:02:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44488 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3KKQB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:01:59 -0500
Message-ID: <5280FF5E.2090009@zytor.com>
Date: Mon, 11 Nov 2013 08:01:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/trace] x86, trace: Add page fault tracepoints
References: <52716E67.6090705@hds.com> <tip-d34603b07c4255b2b00a546d34f297ccd50ae4c6@git.kernel.org> <20131111082955.GB12405@gmail.com>
In-Reply-To: <20131111082955.GB12405@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 12:29 AM, Ingo Molnar wrote:
> 
> Nice!
> 
> It would be nice to change this to hierarchical naming:
> 
>    page_fault_user
>    page_fault_kernel
> 
> I.e. the higher level concept named first and go to the left, details go 
> to the right.
> 
> (That way x86_exceptions.page_fault_user has the names ordered correctly 
> as well.)
> 

Seiji - are you okay with this?  If so I'll just make a quick patch now.

	-hpa



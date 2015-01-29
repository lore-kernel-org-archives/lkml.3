Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbbA2ExJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:53:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39035 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbbA2ExG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:53:06 -0500
Message-ID: <54C9BCA3.2020102@linux.vnet.ibm.com>
Date: Thu, 29 Jan 2015 10:22:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, aik@ozlabs.ru,
        shreyas@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
References: <20150120103559.8430.50933.stgit@preeti.in.ibm.com> <alpine.DEB.2.11.1501211243270.5526@nanos> <54C09391.9080202@linux.vnet.ibm.com> <alpine.DEB.2.11.1501221209260.5526@nanos> <54C7068B.3050108@linux.vnet.ibm.com> <54C8B3D2.3070608@linux.vnet.ibm.com> <20150128213123.GA27411@localhost.localdomain>
In-Reply-To: <20150128213123.GA27411@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012904-0009-0000-0000-000008577626
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 03:01 AM, Richard Cochran wrote:
> On Wed, Jan 28, 2015 at 03:32:58PM +0530, Preeti U Murthy wrote:
>> Thomas ping. Would you be posting this patch?
> 
> FYI, Thomas is temporarily out of action, in bed with the flu.

Oh I am sorry to hear that! Let me post out a patch based on Thomas's
suggestions around this.

Wishing him a speedy recovery.

Regards
Preeti U Murthy
> 
> Thanks,
> Richard
> 


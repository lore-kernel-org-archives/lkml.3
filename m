Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3BMAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:32:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58769 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab3BMAca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:32:30 -0500
Message-ID: <511ADEB7.6080909@zytor.com>
Date: Tue, 12 Feb 2013 16:30:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        tglx@linutronix.de, JBeulich@suse.com, bp@alien8.de
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
References: <1360164359-12273-1-git-send-email-kys@microsoft.com> <20130206191313.GA1470@kroah.com>
In-Reply-To: <20130206191313.GA1470@kroah.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 11:13 AM, Greg KH wrote:
> On Wed, Feb 06, 2013 at 07:25:59AM -0800, K. Y. Srinivasan wrote:
>> Use the infrastructure for delivering VMBUS interrupts using a
>> special vector. With this patch, we can now properly handle
>> the VMBUS interrupts that can be delivered on any CPU. Also,
>> turn on interrupt load balancing as well.
>>
>> This patch requires the infrastructure that was implemented in the patch:
>> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
>>
> 
> Because of the dependancy, this should go through the x86 tree as well:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

This does not apply to v3.8-rc7 + the set of three vmbus patches for
x86.  I take it there are additional dependencies -- K.Y., what do I
need here?

	-hpa



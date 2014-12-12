Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080AbaLLU1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:27:45 -0500
Received: from www.sr71.net ([198.145.64.142]:53734 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934871AbaLLU1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:27:44 -0500
Message-ID: <548B4FBE.5090101@sr71.net>
Date: Fri, 12 Dec 2014 12:27:42 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, x86@kernel.org
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net>
In-Reply-To: <548B4E75.5010507@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 12:22 PM, Andy Lutomirski wrote:
> On 12/12/2014 11:12 AM, Dave Hansen wrote:
>> This is 3.20 material.  I'm hoping to get some comments early
>> in case folks have some issues with the way it's being done.
>>
>> The MPX hardware structures differ in layout in 32 and 64-bit
>> mode.  A 32-bit binary running on a 64-bit kernel needs the
>> 32-bit structures, so we need code which switches between
>> the two modes.
> 
> The OS community figured out years ago that you aren't supposed to do
> this.  Did everyone forget to tell the hardware people?

What is your concern with it, exactly?

You want the same size structures with the same format for 32-bit and
64-bit modes?

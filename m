Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967568AbaLLUfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:35:54 -0500
Received: from www.sr71.net ([198.145.64.142]:53824 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365AbaLLUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:35:54 -0500
Message-ID: <548B51A8.3010500@sr71.net>
Date: Fri, 12 Dec 2014 12:35:52 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, x86@kernel.org
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4FA4.40700@amacapital.net>
In-Reply-To: <548B4FA4.40700@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 12:27 PM, Andy Lutomirski wrote:
> On 12/12/2014 11:12 AM, Dave Hansen wrote:
>> This is 3.20 material.  I'm hoping to get some comments early
>> in case folks have some issues with the way it's being done.
> 
> Would it make sense to disable MPX for 32-bit binaries on 64-bit kernels
> for 3.19?

Yes, we probably should do something.  It was an oversight that we
didn't do this explicitly in the stuff that got merged.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3LaUG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:06:58 -0500
Received: from www.sr71.net ([198.145.64.142]:41979 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab3LaUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:06:57 -0500
Message-ID: <52C323DA.4020203@sr71.net>
Date: Tue, 31 Dec 2013 12:06:50 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Re: [PATCH 09/12] x86 Kconfig: create mtrr menu
References: <20131230184046.F5E42919@viggo.jf.intel.com> <20131230184058.0A59E033@viggo.jf.intel.com> <52C31A51.5000102@infradead.org>
In-Reply-To: <52C31A51.5000102@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 11:26 AM, Randy Dunlap wrote:
> On 12/30/13 10:40, Dave Hansen wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>> This removes another 4 lines from the default x86 menu.  Note
>> that I slightly changed the MTRR prompt text since PAT is
>> hidden under here.  This makes PAT easier to find since it
>> "depends on MTRR" anyway.
> 
> I would have put MTRR/PAT in the new Processor Options and Features
> menu.

Sounds good to me.  I'll move it.

> How do you decide what goes where?

It's pretty arbitrary. :)  But, better than what we have now where
almost *EVERYTHING* is hard to find in the noise.

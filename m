Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3CFGaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:30:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49019 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3CFGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:30:04 -0500
Message-ID: <5136E25F.8080903@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 22:29:51 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>, George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: %pa format specifier issues
References: <51369964.6040101@linux.vnet.ibm.com> <5136A7CA.70308@codeaurora.org>
In-Reply-To: <5136A7CA.70308@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030606-4834-0000-0000-000004593951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 06:19 PM, Stephen Boyd wrote:
>> >
>> > Am I doing something really stupid here?
>> >
>> > This is using a 32-bit i386 kernel.
>> >
>>From reading the patch I thought you had to pass the address via
> reference. Otherwise you get the warning like you mention here, and then
> probably an oops when the kernel tries to dereference 0x1234.

Heh, that would qualify as "really stupid". Thanks :)


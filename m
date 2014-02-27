Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaB0ETf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:19:35 -0500
Received: from mail.wdtv.com ([66.118.69.84]:35465 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbaB0ETc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:19:32 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Date: Wed, 26 Feb 2014 23:19:29 -0500
Cc: Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
References: <20140227005246.GB10367@milliways> <1393471595.5519.22.camel@marge.simpson.net> <20140227034535.GC14346@milliways>
In-Reply-To: <20140227034535.GC14346@milliways>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201402262319.30242.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Ken Moffat wrote:
>On Thu, Feb 27, 2014 at 04:26:35AM +0100, Mike Galbraith wrote:
>> I would start with strace to see if a task is looping in userspace,
>> then move on to perf top -g -p <pid> (or perf record/report) to peek
>> at what it's up to in the kernel.  Once you have the where,
>> trace_printk() is the best thing since sliced bread (which ranks just
>> below printk()).
>> 
>> -Mike
>
> Thanks.  I'll need to build perf.
>
>ĸen
I probably will too, but I don't have a huge amount of tracing turned on in 
this kernel.  We'll see what happens tonight & go from there.
FWIW, about all I see in htop is the command line that launched it.


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.


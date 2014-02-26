Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBZCtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:49:05 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38193 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBZCtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:49:03 -0500
Message-ID: <530D561A.4030509@mit.edu>
Date: Tue, 25 Feb 2014 18:48:58 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dieter Mummenschanz <dmummenschanz@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: intel_pstate: Haswell i7-4600M refuses to enter lower Package
 States
References: <trinity-4cc330c5-5df6-41ca-99e3-ea6a43c4ed56-1392899382625@3capp-gmx-bs46>
In-Reply-To: <trinity-4cc330c5-5df6-41ca-99e3-ea6a43c4ed56-1392899382625@3capp-gmx-bs46>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:29 AM, Dieter Mummenschanz wrote:
> Hello,
> 
> on my Lenovo T440p Laptop the Haswell i7-4600M CPU refuses to enter lower PC states resulting in 14-15 Watts continuous power drain even if the system is idle and every tunalbes in powertop 2.5 are enabled. The issue is reproducable with Kernel versions 3.13 up to 3.14-rc3.
> 
> Did anyone else experience a similar issue?

Something's confused here.  Do you mean P-states (i.e. performance
states or "frequency" settings) or PC-states (i.e. "package C-states")?
 I suspect that you mean the latter, in which case intel_pstate has
nothing to do with the problem.

The relevant diagnostic is the output from turbostat.

--Andy

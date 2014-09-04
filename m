Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaIDUf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:35:28 -0400
Received: from bowie.eng.utah.edu ([155.98.110.113]:22415 "EHLO
	bowie.eng.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaIDUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:35:27 -0400
Message-ID: <5408CD0E.9080408@eng.utah.edu>
Date: Thu, 04 Sep 2014 14:35:26 -0600
From: Scotty Bauer <sbauer@eng.utah.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, clemens@ladisch.de
Subject: Re: [PATCH] kern/sys: Compat sysinfo syscall fix undefined behavior
References: <5408B39D.4030400@eng.utah.edu> <20140904131408.5b50c44315263c497ac7d818@linux-foundation.org>
In-Reply-To: <20140904131408.5b50c44315263c497ac7d818@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/04/2014 02:14 PM, Andrew Morton wrote:
> If I'm reading it correctly, this is all dead code because si_meminfo() unconditionally sets sysinfo.mem_unit to PAGE_SIZE. It could all do with a bit of a cleanup, I suspect. 
I'll do a little more research on this and do further clean up, if required.

-Scotty

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaB1HCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:02:45 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:35382 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaB1HCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:02:44 -0500
Message-ID: <5310344F.1060300@rosalab.ru>
Date: Fri, 28 Feb 2014 11:01:35 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] KernelStrider 0.3
References: <530F4776.2050507@rosalab.ru> <87txbkusjl.fsf@tassilo.jf.intel.com>
In-Reply-To: <87txbkusjl.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 01:58 AM, Andi Kleen wrote:
> The interesting part is: what problems did you find using it?
>

I listed some of these here along with the links to the bug reports:
http://code.google.com/p/kernel-strider/wiki/RacesFound

The hunt still continues though.

Besides the races listed there, the tools found a number of less 
significant of benign ones (racy stat updates, etc.).

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA
www.rosalab.com

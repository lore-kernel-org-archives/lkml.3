Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3ERCCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:02:31 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:1712 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3ERCCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:02:30 -0400
Message-ID: <5196E0A1.6000300@spin.net.au>
Date: Sat, 18 May 2013 12:00:01 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: Linux source tree size difference issue
References: <519577DD.3040204@spin.net.au> <20130517194419.GA4002@mobil.systemanalysen.net>
In-Reply-To: <20130517194419.GA4002@mobil.systemanalysen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.823, required 4, AWL 0.68, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 05:44 AM, Roland Eggner wrote:
>
> $  LC_ALL=C du --help  | grep -E -e 'apparent|sparse|fragmentation'
> -------------------------------------------------------------------
>       --apparent-size   print apparent sizes, rather than disk usage; although
>                           the apparent size is usually smaller, it may be
>                           larger due to holes in ('sparse') files, internal
>                           fragmentation, indirect blocks, and the like
>   -b, --bytes           equivalent to '--apparent-size --block-size=1'
>

Thanks Roland. I figured it out in the end. Things were not as bad as
they first seemed.


Regards

-- 

Chris Jones

Founder and Lead Software Architect
Paradise Software
chrisjones@spin.net.au


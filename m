Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3LaT0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:26:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3LaT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:26:16 -0500
Message-ID: <52C31A56.7090106@infradead.org>
Date: Tue, 31 Dec 2013 11:26:14 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Re: [PATCH 01/12] x86 Kconfig: create extended platforms menu
References: <20131230184046.F5E42919@viggo.jf.intel.com> <20131230184047.59278144@viggo.jf.intel.com>
In-Reply-To: <20131230184047.59278144@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 10:40, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This takes the relatively obscure (NUMA-Q anyone?) platforms
> (both 32 and 64-bit) and sticks them in their own menu.
> Virtually nobody needs to set these, and those that do know how
> to find them the hard way.

I'd sorta prefer to see this even further down in the menu list,
but it's not a big deal.


-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3KLFYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 00:24:19 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45294 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3KLFYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 00:24:10 -0500
Message-ID: <5281BB74.50903@gmail.com>
Date: Tue, 12 Nov 2013 07:24:04 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2.1] net: wireless: iwlwifi: remove minor dead code
References: <1384110397-24386-1-git-send-email-mpn@google.com> <527FDB50.1050902@cogentembedded.com> <87iow080zv.fsf@mina86.com> <1384177312.14334.12.camel@jlt4.sipsolutions.net> <xa1tr4amwkrt.fsf@mina86.com>
In-Reply-To: <xa1tr4amwkrt.fsf@mina86.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2013 02:01 AM, Michal Nazarewicz wrote:
> inta is checked to be zero in a IRQ_NONE branch so afterwards it
> cannot be zero as it is never modified.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/net/wireless/iwlwifi/pcie/rx.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> On Mon, Nov 11 2013, Johannes Berg wrote:
>> no signed-off-by
> 
> Sorry, fixed.  Interestingly, I did not forget about it in my first patch.
> 

no worries - I picked it up in our internal tree.
Thanks!

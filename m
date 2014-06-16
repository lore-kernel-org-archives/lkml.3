Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaFPURj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:17:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:46354 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaFPURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:17:38 -0400
X-CheckPoint: {539F50E1-E-2100090A-C0000000}
Message-ID: <539F50E0.3030900@tilera.com>
Date: Mon, 16 Jun 2014 16:17:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on the
 number of CPUs
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>	 <20140611093447.GL7772@pathway.suse.cz>	 <1402596066.2627.1.camel@buesod1.americas.hpqcorp.net> <1402598718.12385.16.camel@joe-AO725>
In-Reply-To: <1402598718.12385.16.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2014 2:45 PM, Joe Perches wrote:
> (adding Chris Metcalf for arch/tile,
>   I think this change might impact that arch)

Thanks for the Cc.  I've been following the discussion and I think it's on the right track for arch/tile.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


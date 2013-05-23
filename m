Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab3EWMyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:54:35 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:37518 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3EWMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:54:33 -0400
Message-ID: <519E117F.9040707@elopez.com.ar>
Date: Thu, 23 May 2013 09:54:23 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: ethernet: sun: drop unused variable
References: <20130522.122624.266893118412034519.davem@davemloft.net> <1369267057-9371-1-git-send-email-emilio@elopez.com.ar> <1369267057-9371-3-git-send-email-emilio@elopez.com.ar> <20130522.234318.1664796969540142910.davem@davemloft.net>
In-Reply-To: <20130522.234318.1664796969540142910.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

El 23/05/13 03:43, David Miller escribió:
> From: Emilio López <emilio@elopez.com.ar>
> Date: Wed, 22 May 2013 20:57:37 -0300
> 
>> Commit bfd428d ("net: ethernet: sun: initialize variables directly")
>> dropped the only loop that was using i but did not remove the actual
>> variable, therefore causing a warning when building. This patch drops
>> the now redundant line.
>>
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> 
> Applied.

I see that you applied the series in net instead of net-next; the
previous patches were in net-next only. This will cause build breakage
in net because the loop is still there.

Regards,

Emilio

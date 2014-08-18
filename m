Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaHRHZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:25:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaHRHZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:25:42 -0400
Message-ID: <53F1AA76.2020306@infradead.org>
Date: Mon, 18 Aug 2014 00:25:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Markus Osterhoff <mo@mo-online.org>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [TYPO 4/9] [typo] COPYING: form feeds removed
References: <20140817183033.GE4077@mo-online.de>
In-Reply-To: <20140817183033.GE4077@mo-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/14 11:30, Markus Osterhoff wrote:
> some lines contain a single ^L (ASCII 0xc, 12, form feed),
> which are unnecessary.
> 
> Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
> ---
>  COPYING | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

The form feeds have been there forever AFAIK.  I expect that they were put there
on purpose.  They are mostly a Don't Care One Way Or The Other IMO.


-- 
~Randy

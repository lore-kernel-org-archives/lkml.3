Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaJCPZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:25:05 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:59204 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbaJCPZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:25:02 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 11:25:02 EDT
Message-ID: <542EBD99.2030607@akamai.com>
Date: Fri, 03 Oct 2014 11:15:37 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] dynamic_debug: change __dynamic_<foo>_dbg return types
 to void
References: <1411582676.3594.12.camel@joe-AO725>
In-Reply-To: <1411582676.3594.12.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 02:17 PM, Joe Perches wrote:
> The return value is not used by callers of these functions
> so change the functions to return void.
> 

Acked-by: Jason Baron <jbaron@akamai.com>

Greg - can you pick this up?

Thanks,

-Jason

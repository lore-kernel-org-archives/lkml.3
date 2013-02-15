Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682Ab3BOO4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:56:17 -0500
Received: from xes-mad.com ([216.165.139.218]:35307 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161283Ab3BOO4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:56:13 -0500
Date: Fri, 15 Feb 2013 08:56:10 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH] lpc_ich: use devres API to allocate private data
Message-ID: <46a1992b-31c7-4b60-a725-a1f4c50747d4@zimbra>
In-Reply-To: <9be5e8ee-d1b9-4509-b147-879281e10efc@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC24 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
> From: "Aaron Sierra" <asierra@xes-inc.com>
> To: "Samuel Ortiz" <sameo@linux.intel.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>
> Sent: Thursday, February 14, 2013 11:35:04 AM
> Subject: [PATCH] lpc_ich: use devres API to allocate private data
>
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---

[trim]

> -	priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> +	priv = devm_kzalloc(&dev->dev,
> +			    sizeof(struct lpc_ich_priv), GFP_KERNEL);

Samuel,
Perhaps this should now include a comment about this patch also resolving the issue that Anatol reported yesterday?

-Aaron

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaIZSIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:08:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:62463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaIZSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:08:50 -0400
X-IronPort-AV: E=Sophos;i="5.04,604,1406592000"; 
   d="scan'208";a="176602907"
Message-ID: <5425ABB0.7000706@citrix.com>
Date: Fri, 26 Sep 2014 19:08:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xen/xenbus: Remove BUG_ON() when error string trucated
References: <542587E3.4040605@gmail.com>
In-Reply-To: <542587E3.4040605@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 16:36, Chen Gang wrote:
> xenbus_va_dev_error() is for printing error, so when error string is
> too long to be truncated, need not BUG_ON(), still return truncation
> string is OK.

Applied to devel/for-linus-3.18

Thanks.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbaIZSIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:08:49 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50511 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbaIZSIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:08:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,604,1406592000"; 
   d="scan'208";a="175569689"
Message-ID: <5425AB98.20103@citrix.com>
Date: Fri, 26 Sep 2014 19:08:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xen/xenbus: Correct the comments for xenbus_grant_ring()
References: <54258785.4070803@gmail.com>
In-Reply-To: <54258785.4070803@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 16:34, Chen Gang wrote:
> A grant reference (which is a positive number) can indicate success, so
> the original comments need be improved.

Applied to devel/for-linus-3.18.

Thanks.

David

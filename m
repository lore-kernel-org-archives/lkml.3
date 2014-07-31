Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaGaR67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:58:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27248 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaGaR65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:58:57 -0400
X-IronPort-AV: E=Sophos;i="5.01,773,1400025600"; 
   d="scan'208";a="157616882"
Message-ID: <53DA83DE.10907@citrix.com>
Date: Thu, 31 Jul 2014 18:58:54 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <wei.liu2@citrix.com>, <tglx@linutronix.de>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/4] drivers/xen/events/events_base.c: drop negativity
 check of unsigned parameter
References: <1405614350-4453-1-git-send-email-andrey.krieger.utkin@gmail.com>
In-Reply-To: <1405614350-4453-1-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 17:25, Andrey Utkin wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80531
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Applied to devel/for-linus-3.17.

Thanks.

David

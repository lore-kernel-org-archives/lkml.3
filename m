Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaI2N5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:57:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25814 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaI2N5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:57:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,620,1406592000"; 
   d="scan'208";a="177097529"
Message-ID: <54296559.5020301@citrix.com>
Date: Mon, 29 Sep 2014 14:57:45 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Juergen Gross <jgross@suse.com>,
        Jan Beulich <JBeulich@suse.com>
CC: <xen-devel@lists.xenproject.org>, David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
References: <5425967F.7020002@gmail.com> <5428E0ED.1050107@suse.com>	<54293742020000780003A48A@mail.emea.novell.com>	<54292707.90008@gmail.com> <542927C3.8010204@suse.com> <54292D6E.4060903@gmail.com>
In-Reply-To: <54292D6E.4060903@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 10:59, Chen Gang wrote:
> 
> 
> If no any additional reply within 2 days, I shall send patch v2 for it:
> 
>   "use dev_warn() instead of xenbus_dev_error() and remove 'fail' code block"

I think this driver is fine as-is and does not need any changes.

David

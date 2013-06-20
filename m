Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab3FTTSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:18:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:10353 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab3FTTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:18:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="30925888"
Message-ID: <51C35568.5050600@citrix.com>
Date: Thu, 20 Jun 2013 20:18:00 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 0/4] xen: maintain an accurate persistent clock in more
 cases
References: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 20:13, David Vrabel wrote:
> Xen guests use the Xen wallclock as their persistent clock.  This is a
> software only clock in the hypervisor that is used by guests instead
> of a real hardware RTC.

Sorry, I accidentally specified the wrong revision range and only
include 2 out 4 of the patches in the series.

I have resent the complete series.

David

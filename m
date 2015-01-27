Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbbA0O2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:28:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41651 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbbA0O2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:28:49 -0500
Message-ID: <54C7A07F.2060109@roeck-us.net>
Date: Tue, 27 Jan 2015 06:28:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michael Brunner <mibru@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        Michael Brunner <michael.brunner@kontron.com>,
        Christian Rauch <christian.rauch@kontron.com>
Subject: Re: [PATCH] mfd: Add support for COMe-cBL6 to Kontron PLD driver
References: <20150127110549.0e15be0e@hyperion>
In-Reply-To: <20150127110549.0e15be0e@hyperion>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C7A0A1.0116,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 14
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 5
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 02:05 AM, Michael Brunner wrote:
> This patch adds the DMI system ID of the Kontron COMe-cBL6 board to
> the Kontron PLD driver. The list of supported products in the module
> description is also updated.
>
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Acked-by: Christian Rauch <christian.rauch@kontron.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


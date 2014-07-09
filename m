Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaGIKOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:14:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34642 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaGIKOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:14:09 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "peter.senna@gmail.com" <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rmfrfs@gmail.com" <rmfrfs@gmail.com>,
        "teobaluta@gmail.com" <teobaluta@gmail.com>
Subject: RE: [PATCH v2 1/4] staging: rtl8192u: Remove useless return
 statement in r819xU_phy.c
Thread-Topic: [PATCH v2 1/4] staging: rtl8192u: Remove useless return
 statement in r819xU_phy.c
Thread-Index: AQHPmzoE2xF1VKdhOEKbJTxgsZWmZZuXUw+AgAAuJOA=
Date: Wed, 9 Jul 2014 10:14:04 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE938EF8E4A@EU-MBX-04.mgc.mentorg.com>
References: <20140708100142.GR25934@mwanda>
 <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404885860-19468-2-git-send-email-sanjeevsharmaengg@gmail.com>
 <20140709080943.GT25880@mwanda>
In-Reply-To: <20140709080943.GT25880@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jul 2014 10:14:06.0923 (UTC) FILETIME=[847FC1B0:01CF9B5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dan,


-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, July 09, 2014 1:40 PM
To: sanjeev sharma
Cc: gregkh@linuxfoundation.org; devel@driverdev.osuosl.org; peter.senna@gmail.com; linux-kernel@vger.kernel.org; rmfrfs@gmail.com; teobaluta@gmail.com; Sharma, Sanjeev
Subject: Re: [PATCH v2 1/4] staging: rtl8192u: Remove useless return statement in r819xU_phy.c

These patches look ok now.  The only thing is that the changelogs are a little off.

On Wed, Jul 09, 2014 at 11:34:17AM +0530, sanjeev sharma wrote:
> From: sanjeev sharma <sanjeev_sharma@mentor.com>

Don't use the From header unless you are sending patches on behalf of someone else.  It's better if you can configure your email client so you can send the patches from your @mentor.com address.  It would be better if the names were capitalized.

I will take care for future patches and configure email client by using mentor address.

> 
> This is a patch to the r819xU_phy.c file that remove unneeded return statements in code.

Please line wrap the changelog at 72 characters (the same as email).
Otherwise Greg sometimes fixes them manually...

But the patches themselves are nice now.

@Greg.,@Dan: Is it Ok if this can be taken care in future.

regards,
dan carpenter


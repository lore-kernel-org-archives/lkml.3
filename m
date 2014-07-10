Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaGJMT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:19:28 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:58435 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaGJMT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:19:26 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "peter.senna@gmail.com" <peter.senna@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rmfrfs@gmail.com" <rmfrfs@gmail.com>,
        "teobaluta@gmail.com" <teobaluta@gmail.com>
Subject: RE: [PATCH v3 1/4] staging: rtl8192u: Remove useless return
 statements.
Thread-Topic: [PATCH v3 1/4] staging: rtl8192u: Remove useless return
 statements.
Thread-Index: AQHPm251kAU+EhUpWkqJnR/otjZ+jZuYDzyAgAEsGpA=
Date: Thu, 10 Jul 2014 12:19:23 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE938EFFA8F@EU-MBX-04.mgc.mentorg.com>
References: <20140708100142.GR25934@mwanda>
 <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404908382-7043-2-git-send-email-sanjeevsharmaengg@gmail.com>
 <20140709192441.GB4593@kroah.com>
In-Reply-To: <20140709192441.GB4593@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Jul 2014 12:19:25.0771 (UTC) FILETIME=[307EA9B0:01CF9C39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Greg for review.

Change has been just pushed now with version 4.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, July 10, 2014 12:55 AM
To: sanjeev sharma
Cc: devel@driverdev.osuosl.org; peter.senna@gmail.com; linux-kernel@vger.kernel.org; rmfrfs@gmail.com; teobaluta@gmail.com; Sharma, Sanjeev
Subject: Re: [PATCH v3 1/4] staging: rtl8192u: Remove useless return statements.

On Wed, Jul 09, 2014 at 05:49:39PM +0530, sanjeev sharma wrote:
> From: sanjeev sharma <sanjeev_sharma@mentor.com>

No "S" characters?

And your 0/4 Subject: was really odd, please fix up and resend all of these.

greg k-h

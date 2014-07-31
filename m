Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaGaFdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:33:09 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64758 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaGaFdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:33:08 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "oort10@gmail.com" <oort10@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:r8190: coding style: Fixed checkpatch reported
 Error
Thread-Topic: [PATCH] staging:r8190: coding style: Fixed checkpatch reported
 Error
Thread-Index: AQHPqxwxnGS1gF35cUaRgMsW7YZmCpu5Q7wAgABnpNA=
Date: Thu, 31 Jul 2014 05:33:05 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE938F055BE@EU-MBX-04.mgc.mentorg.com>
References: <1406632313-2187-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140731002124.GB6157@kroah.com>
In-Reply-To: <20140731002124.GB6157@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 31 Jul 2014 05:33:07.0315 (UTC) FILETIME=[E87A3C30:01CFAC80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I have resent all the patches in order. Please review.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, July 31, 2014 5:51 AM
To: Sharma, Sanjeev
Cc: devel@driverdev.osuosl.org; oort10@gmail.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:r8190: coding style: Fixed checkpatch reported Error

On Tue, Jul 29, 2014 at 04:41:53PM +0530, Sanjeev Sharma wrote:
> This is a patch to the r8190_rtl8256.c file that fixes checkpatch 
> reported space & coding style issues.
> 
> Signed-off-by: Sanjeev Sharma<Sanjeev_Sharma@mentor.com>

Please use a ' ' character...

Please resend all of your patches, they don't have signed-off-by lines, and I don't know what order to apply them in, even if I could do so.

greg k-h

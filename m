Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3APVub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:50:31 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4555 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab3APVu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:50:28 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Stephen Hurd" <shurd@broadcom.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Thread-Topic: [PATCH] 8250/16?50: Add support for Broadcom TruManage
 redirected serial port
Thread-Index: Ac3X/4FKNqFbK6eQTReu1x6E0ZsPbAABcioQABhQpwAAD6vfsAbVMsOAAA5BMhA=
Date: Wed, 16 Jan 2013 21:49:36 +0000
Message-ID: <156984479488CD49A184F5CAB4AF934606FF8308@IRVEXCHMB14.corp.ad.broadcom.com>
References: <156984479488CD49A184F5CAB4AF934606FF55F8@IRVEXCHMB14.corp.ad.broadcom.com>
 <20121212044522.GA7224@kroah.com>
 <156984479488CD49A184F5CAB4AF934606FF5627@IRVEXCHMB14.corp.ad.broadcom.com>
 <20130116065905.GA20170@kroah.com>
In-Reply-To: <20130116065905.GA20170@kroah.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.208.64]
MIME-Version: 1.0
X-WSS-ID: 7CE9FF821ZS8018840-19-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch was against 3.7, not 2.7, 2.7 was a typo.

I'll just pass it off to a Linux developer if I meet one.  Sorry for wasting your time.


-- Stephen Hurd

-----Original Message-----
From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, January 15, 2013 10:59 PM
To: Stephen Hurd
Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250/16?50: Add support for Broadcom TruManage redirected serial port

On Wed, Dec 12, 2012 at 05:28:35AM +0000, Stephen Hurd wrote:
> From: Stephen Hurd <shurd@broadcom.com>
> 
> Add support for the UART device present in Broadcom TruManage capable NetXtreme chips (ie: 5761m 5762, and 5725).
> 
> This implementation has a hidden transmit FIFO, so running in single-byte interrupt mode results in too many interrupts.  The UART_CAP_HFIFO capability was added to track this.  It continues to reload the THR as long as the THRE and TSRE bits are set in the LSR up to a specified limit (1024 is used here).
> 
> Signed-off-by: Stephen Hurd <shurd@broadcom.com>
> 
> ---
> 
> Patch against linux-2.7 from ftp.kernel.org downloaded Dec-11-2012.

2.7?

I need this against the linux-next release, can you please redo it, and
not send it as an attachment, but put it all inline in the email
properly like Documentation/email_clients.txt says?

thanks,

greg k-h



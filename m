Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaHSJir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:38:47 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48415 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSJip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:38:45 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "kraxel@redhat.com" <kraxel@redhat.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: RE: [PATCH v3] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Thread-Topic: [PATCH v3] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Thread-Index: AQHPtfZ/zzZmyRFO50yw6W1X3K4CA5vMcJ8AgAATFQCACv8JQIAAIRWAgAASrnA=
Date: Tue, 19 Aug 2014 09:38:41 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2FE70@EU-MBX-02.mgc.mentorg.com>
References: <yes>
 <1407825621-23322-1-git-send-email-sanjeev_sharma@mentor.com>
 <53E9B418.3050303@redhat.com>
 <FDC088D3B5555644AE135ED28A7ABDE94DF2FDA2@EU-MBX-02.mgc.mentorg.com>
 <20140819093047.GA991@kroah.com>
In-Reply-To: <20140819093047.GA991@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Aug 2014 09:38:43.0594 (UTC) FILETIME=[5DD536A0:01CFBB91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for letting me know.

Sanjeev Sharma

-----Original Message-----
From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, August 19, 2014 3:01 PM
To: Sharma, Sanjeev
Cc: kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Hans de Goede
Subject: Re: [PATCH v3] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

On Tue, Aug 19, 2014 at 06:33:04AM +0000, Sharma, Sanjeev wrote:
> Hi Greg,
> 
> Any feedback on this patch ?

The merge window ended 2 days ago, _and_ I'm at the kernel summit this week, _and_ my queue is currently sitting at:
	$ mdfrm -c ~/mail/todo/
	1317 messages in /home/gregkh/mail/todo/

So please be patient.  I'll get to it in a few weeks.

greg k-h

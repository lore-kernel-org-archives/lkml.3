Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaHLG2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:28:43 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63524 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaHLG2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:28:42 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Thread-Topic: [PATCH v2] uas: replace WARN_ON_ONCE() with
 lockdep_assert_held()
Thread-Index: AQHPtfISELfQBLxdbUafgMxB3jwDHJvMaSyAgAAYM9A=
Date: Tue, 12 Aug 2014 06:28:39 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B40D@EU-MBX-02.mgc.mentorg.com>
References: <1407823717-17265-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140812060153.GB13231@kroah.com>
In-Reply-To: <20140812060153.GB13231@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Aug 2014 06:28:41.0198 (UTC) FILETIME=[A89568E0:01CFB5F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done !

Thanks
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, August 12, 2014 11:32 AM
To: Sharma, Sanjeev
Cc: hdegoede@redhat.com; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] uas: replace WARN_ON_ONCE() with lockdep_assert_held()

On Tue, Aug 12, 2014 at 11:38:37AM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and 
> therefore it would be advise to replace with lockdep_assert_held().

Add "on some architectures" in here somewhere, as it's not broken on the large majority of UP cpus :)

thanks,

greg k-h

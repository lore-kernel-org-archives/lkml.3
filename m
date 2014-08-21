Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaHUMYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:24:40 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:52692 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaHUMYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:24:38 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: gregkh <gregkh@linuxfoundation.org>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:iio: moved platform_data into include/linux/iio
Thread-Topic: [PATCH] staging:iio: moved platform_data into include/linux/iio
Thread-Index: AQHPvD/0dxnEQqo0D0eqpJHW9TvQ6ZvY+PeAgAACRoCAAAFvgIAAA5UAgABGnoCAAbWjIA==
Date: Thu, 21 Aug 2014 12:24:35 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF31397@EU-MBX-02.mgc.mentorg.com>
References: <1408516869-6099-1-git-send-email-sanjeev_sharma@mentor.com>
 <53F441FF.9090304@metafoo.de>
 <CAGUYZuSENkSjoA9U0E8MQKp0a1J3moE8p8NYAzfiZ+BpxND4Aw@mail.gmail.com>
 <53F4451B.3040209@metafoo.de>
 <CAGUYZuQwKMG0OFt_gJVPTj3EWin68Jg3jzD9T_Rje-UroOCf=g@mail.gmail.com>
 <20140820111537.GA12663@kroah.com>
In-Reply-To: <20140820111537.GA12663@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 21 Aug 2014 12:24:36.0880 (UTC) FILETIME=[DF47A100:01CFBD3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks greg TODO was very confusing.

@Lars: These drivers are looks stable enough to move out of staging tree and Can we move to outside staging tree as per your 1st Comment.

Regards
Sanjeev Sharma

-----Original Message-----
From: gregkh [mailto:gregkh@linuxfoundation.org] 
Sent: Wednesday, August 20, 2014 4:46 PM
To: sanjeev sharma
Cc: Lars-Peter Clausen; Sharma, Sanjeev; jic23@kernel.org; linux-iio@vger.kernel.org; devel; linux-kernel
Subject: Re: [PATCH] staging:iio: moved platform_data into include/linux/iio


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Aug 20, 2014 at 12:32:52PM +0530, sanjeev sharma wrote:
> Hi,
> 
> I have only moved some header files because other header files are 
> already present there and these are only pending files which is not 
> moved outside the staging directory.
> 
> @Greg:What is your though on this ?

Lars-Peter is correct, don't "leak" files from staging.  Take the time to work on fixing up these drivers correctly so they can be moved out of staging instead of just doing simple file moves which do nothing.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaHKL6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:58:42 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48862 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaHKL6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:58:41 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "steve.glendinning@shawell.net" <steve.glendinning@shawell.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
Thread-Topic: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
Thread-Index: AQHPtTq5zUyjXrbfeEGo5ny0RRaI85vK/u6AgABNL6A=
Date: Mon, 11 Aug 2014 11:58:38 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B2C5@EU-MBX-02.mgc.mentorg.com>
References: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811082015.GA1422@kroah.com>
In-Reply-To: <20140811082015.GA1422@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Aug 2014 11:58:39.0733 (UTC) FILETIME=[97045A50:01CFB55B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok Greg probably Steve will have a look.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Monday, August 11, 2014 1:50 PM
To: Sharma, Sanjeev
Cc: steve.glendinning@shawell.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()

On Mon, Aug 11, 2014 at 01:46:23PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration and 
> therefore it would be advise to repalce with WARN_ON_SMP().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/net/ethernet/smsc/smsc911x.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hint, I have nothing to do with this file, no need to send a patch for it to me, I can't do anything with it...

thanks,

greg k-h

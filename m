Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaHLFWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:22:52 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60321 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaHLFWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:22:50 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: David Miller <davem@davemloft.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "steve.glendinning@shawell.net" <steve.glendinning@shawell.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
Thread-Topic: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
Thread-Index: AQHPtTq5zUyjXrbfeEGo5ny0RRaI85vL3gQAgACSIhA=
Date: Tue, 12 Aug 2014 05:22:46 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B3B6@EU-MBX-02.mgc.mentorg.com>
References: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811.143842.1765285724858937860.davem@davemloft.net>
In-Reply-To: <20140811.143842.1765285724858937860.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Aug 2014 05:22:48.0860 (UTC) FILETIME=[74CE7DC0:01CFB5ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks !

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Tuesday, August 12, 2014 3:09 AM
To: Sharma, Sanjeev
Cc: gregkh@linuxfoundation.org; steve.glendinning@shawell.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()

From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Date: Mon, 11 Aug 2014 13:46:23 +0530

> spin_is_locked() always return false in uniprocessor configuration and 
> therefore it would be advise to repalce with WARN_ON_SMP().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

This looks fine, applied, thanks.

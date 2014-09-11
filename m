Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaIKWAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:00:36 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:35217
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbaIKWAe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:00:34 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Thread-Topic: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Thread-Index: AQHPzBidpyB9E37aHUyfPTFUHQsjBpv8NngQgAC36YD//5AnIA==
Date: Thu, 11 Sep 2014 22:00:32 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F992CA@P3PWEX4MB008.ex4.secureserver.net>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F9872E@P3PWEX4MB008.ex4.secureserver.net>
 <20140911213741.GA4542@kroah.com>
In-Reply-To: <20140911213741.GA4542@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2014 2:38 PM, Greg Kroah-Hartman wrote:
> On Thu, Sep 11, 2014 at 05:57:34PM +0000, Hartley Sweeten wrote:
>> Just wanted to give you a heads up on this series and the ones I have
>> posted. The series are:
>> 
>>> From Ian, [PATCH 00/48] staging: comedi: avoid using comedi_board()
>>> From me, [PATCH 00/30] staging: comedi: adl_pci9118: continue cleanup
>>> From me, [PATCH 00/34] staging: comedi: cleanup async cmd->stop_{src,arg} usage
>> 
>> There are a couple conflicts between the series from Ian and my two.
>> If you drop these two from Ian's series:
>>  
>> 06) staging: comedi: adl_pci9118: replace comedi_board() calls
>> 10) staging: comedi: amplc_dio200_common: replace comedi_board() calls
>> 
>> The rest will apply cleanly in the order above (assuming I didn't miss anything).
>
> I applied all of the above, with the 2 patches from Ian going last and
> git handling the merge issues.
>
>> Also, Ian had a couple issues with patch 07/34 and 08/34 from the last
>> series I posted. I already asked if you could drop those two. I needed I
>> will repost the series.
>
> I've dropped them.  Hopefully I got it all right, it should all be
> pushed out now, verifying this would be good :)

A quick glance looks like everything is right. I'll give it a better look
when it hits linux-next.

Thanks,
Hartley


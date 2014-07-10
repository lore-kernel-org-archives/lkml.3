Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaGJPYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:24:47 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:4942 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaGJPYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:24:45 -0400
X-LoopCount0: from 10.170.28.41
X-IronPort-AV: E=Sophos;i="5.01,638,1400043600"; 
   d="scan'208";a="666158946"
From: <B_B_Singh@DELL.com>
To: <gregkh@linuxfoundation.org>
CC: <tiwai@suse.de>, <Abhay_Salunke@DELL.com>, <arnd@arndb.de>, <kay@vrfy.org>,
        <ming.lei@canonical.com>, <sr@denx.de>, <teg@jklm.no>,
        <Stuart_Hayes@DELL.com>, <Srinivas_G_Gowda@DELL.com>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jul 2014 08:24:36 -0700
Subject: RE: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
Thread-Topic: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
Thread-Index: Ac+cTuVUq3rtYsq6Sb2WudbwheHWTQAA54nA
Message-ID: <8B2F6FFD0BD1E448853114367400A37306FD6FBC09@BLRX7MCDC203.AMER.DELL.COM>
References: <14048583172593@kroah.com>
 <8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
 <20140710143144.GA17639@kroah.com>
 <8B2F6FFD0BD1E448853114367400A37306FD6FBBF0@BLRX7MCDC203.AMER.DELL.COM>
 <20140710145417.GB18412@kroah.com>
In-Reply-To: <20140710145417.GB18412@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.29.3
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=No
 Restrictions;Sublabels=;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7InDH93xORGEHKbA9IfhlEtn0qHTQFq3peMi1oTN1blvyvYuo1qgfJV7Hw3Wmh3Zl2qAkIKTy5uMotBLYynVY90QfrYbuBMDR6PhiGcJ8+jL/TRK0VzliY3AoVDXA9WbnI5NKGzNCCxKKOkcPwGOk58mV3bTRFo9skQ7WxIuKIz9sTbb/HnG7Z0IGuOudHOXnBJEwxWpno8oWkLCzSdltjKQM+lvBrq0xolISGf3WXugQtwZawQv4SCiQM2blR9VPPPcRUc3IC9x+11yeNzgXu2nibEJ5JybIdxSOAaWVyZeh
x-titusconfig: 1.4AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Greg,

Here is the patch which I was referring to https://lkml.org/lkml/2014/6/4/327

I was doing the BIOS update test using the DELL BIOS-DUP's with the above patch.

Will provide you more technical analysis on why it is failing by tomorrow.

Regards
Balaji Singh

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org]
Sent: Thursday, July 10, 2014 8:24 PM
To: Singh, B B
Cc: tiwai@suse.de; Abhay_Salunke@dell.com; arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com; sr@denx.de; teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G; linux-kernel@vger.kernel.org
Subject: Re: patch "firmware loader: allow disabling of udev as firmware loader" added to driver-core tree

On Thu, Jul 10, 2014 at 08:10:01PM +0530, B_B_Singh@DELL.com wrote:
> Resending the mail..
> 
> Hi All,
> 
> As I communicated earlier the test never passed with older BIOS DUPs.

That test? What patch? Please be explicit, I deal with thousands of patches and have no short term memory...

> Again today I have tested with 3.15.5 kernel with below patch applied, 
> & I don't see the BIOS getting updated. The BIOS update always failed 
> with below patch.
> 
> I'm not sure why the patch is getting committed even upon failure.

Because in that long and winding email thread I thought you said this patch _worked_. Obviously I was wrong, sorry, please suggest an alternative.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaDHG4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:56:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:29679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbaDHG4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:56:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,816,1389772800"; 
   d="scan'208";a="516699377"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Topic: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Index: AQHPS0iuvgiDnehMNEeghRTCX5Z79Jr4hhDwgAJi2QCAADLdEIADEokAgAA5rQD//9ENgIAH8M5Q///W/gCAAI6bcIAAlTGAgAAy3YA=
Date: Tue, 8 Apr 2014 06:56:04 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7D28@HASMSX106.ger.corp.intel.com>
References: <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
 <20140407132530.GF3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7512@HASMSX106.ger.corp.intel.com>
 <20140408064953.GH3339@pcnci.linuxbox.cz>
In-Reply-To: <20140408064953.GH3339@pcnci.linuxbox.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nikola Ciprich [mailto:nikola.ciprich@linuxbox.cz]
> Sent: Tuesday, April 08, 2014 09:50
> To: Winkler, Tomas
> Cc: Greg KH (gregkh@linuxfoundation.org); linux-kernel@vger.kernel.org; Nikola
> Ciprich
> Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
> > Sorry for asking but can you please double check your compilation setup.
> 
> You're right of course :-(
> 
> I tried rebuilding rpm again now, and patch spits following:
> 
> Hunk #1 succeeded at 105 (offset -2 lines).
> patch unexpectedly ends in middle of line
> 
> it's bad rpm build didn't abort at this point, but apparently
> this is patch's fault:
> 
> [root@dev6 linux-3.10]# cat /tmp/mei/1 | patch -sp1
> patch unexpectedly ends in middle of line
> [root@dev6 linux-3.10]# echo $?
> 0
> 
> :-(
> 
> well, this sucks, I really wouldn't expect that kind of bug in such widely
> used program as patch :(
>
> I'll report that.


> (btw this error was caused by one whitespace character at last line of patch)

This is really strange, can it be that your mailer has introduced some blanks into the patch,
I've checked that patch applies to all relevant stable kernels.
 
> anyways, You can certainly forgot about that, it was my fault :(
> 
> sorry about that

No harm done, it's good this was sorted out.
Thanks
Tomas
 


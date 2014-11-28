Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaK1VKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:10:17 -0500
Received: from sender1.zohomail.com ([74.201.84.155]:29041 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaK1VKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:10:14 -0500
X-Greylist: delayed 21984 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 16:10:14 EST
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC PATCH 1/3] Add generic TrustZone driver
From: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>
In-Reply-To: <20141128191507.GA7804@kroah.com>
Date: Fri, 28 Nov 2014 22:09:55 +0100
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        joshc@codeaurora.org, johannes.thumshirn@men.de,
        kheitke@codeaurora.org, laurent.pinchart+renesas@ideasonboard.com,
        geert+renesas@glider.be, horms+renesas@verge.net.au,
        damm@opensource.se, tomi.valkeinen@ti.com, mbohan@codeaurora.org,
        michal.simek@xilinx.com, pawel.moll@arm.com, Andrew.Thoelke@arm.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C14B741B-C303-419E-81FB-250D1FDC2D45@javigon.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com> <1417187016-7731-2-git-send-email-javier@javigon.com> <20141128191507.GA7804@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1878.6)
X-ZohoMailClient: External
X-Zoho-Virus-Status: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28 Nov 2014, at 20:15, Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Nov 28, 2014 at 04:03:34PM +0100, Javier González wrote:
>> From: Javier Gonzalez <javier@javigon.com>
> 
> Any reason you sent this twice?
My mistake, sorry.

> 
> And your code is full of FIXMEs, which implies that you aren't even
> happy with the code, so why would we want to review it as-is now?
> 
The driver is still in development, but I think it is mature enough as to
involve more people interested in TrustZone. I have dealt the development
repository with parties that I know are want to contribute in this effort; still
I think that this is the right place to find both interested people, and
good feedback - therefore the RFC.

> Please come up with a design, and implementation, that you feel
> comfortable with before asking others to do work to review your broken
> implementation.

My interest lays more in the interface part. I have worked with different
TrustZone frameworks and one of the main issues with them is that
there is no standard interface from within the kernel. I strongly believe
that having a supported driver in the kernel with a defined interface can
help getting more people involved in porting more TrustZone drivers, and
in general facilitating TrustZone's use. This is of special relevance for 
mobile devices today, but with ARMv8 down the corner servers and set-top
boxes would also profit.

Regarding the interface in itself, I am mostly comfortable with the design and
implementation, but I am sure it is still improbable.

Most of the FIXMEs are in a specific driver I ported. It is aTrustZone open
source implementation called Open Virtualization. I still need to work in 
improving the code, but it performs pretty good at the moment. My intention 
is to continue working on it, but in the meantime I think it is worth getting 
feedback from more experience kernel hackers.

> 
>> +static void trustzone_dev_release(struct device *dev)
>> +{
>> +	/* FIXME: You need to fix all this crap... */
> 
> Yes you do, why you are asking others to do your work is beyond my
> comprehension...
> 

Not the most appropriate comment, I agree. But as I mentioned, it is work in 
progress, and my intention is to get more people involved and obtain early
feedback in a working prototype.

Thanks for your comments. I hope that you find the time to look deeper
in the code.

> greg k-h

Best,

Javier.



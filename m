Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3CTQGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:06:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.5]:61288 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab3CTQGj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:06:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1363795502!6339186!37
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Mar 2013 11:06:16 -0500
Subject: RE: [PATCH] Staging: comedi: serial2002: fixed consistent spacing
 issue
Thread-Topic: [PATCH] Staging: comedi: serial2002: fixed consistent spacing
 issue
Thread-Index: Ac4lhJBhVPznTjk/QM2qEuZOSoIq+AAAA2Mw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00209801072F8@AUSP01VMBX24.collaborationhost.net>
References: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
	 <20130320124753.GZ9138@mwanda> <20130320152951.GO21522@ZenIV.linux.org.uk>
 <1363795450.16270.33.camel@joe-AO722>
In-Reply-To: <1363795450.16270.33.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 20, 2013 9:04 AM, Joe Perches wrote:
> On Wed, 2013-03-20 at 15:29 +0000, Al Viro wrote:
>> On Wed, Mar 20, 2013 at 03:47:53PM +0300, Dan Carpenter wrote:
>> 
>>> The original code here needs to broken up into functions so it isn't
>>> squashed up against the 80 character limit.
>> 
>> I'd say what needs to be done to the original code...
>
> All good things, thanks for taking the time to write it Al.
> Not that I'm ever touching comedi code, but Hartley is, so
> I'm adding him to cc just in case he didn't see it...

I saw it.

I haven't touched this driver yet because I haven't worked out
a clean way to fix the sparse warnings in it.

I'll get to it eventually. :-)

Regards,
Hartley


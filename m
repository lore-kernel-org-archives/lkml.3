Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3HMKiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:38:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab3HMKiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:38:11 -0400
Date: Tue, 13 Aug 2013 12:38:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Hard lockups using 3.10.0
Message-ID: <20130813103808.GA4077@pd.tnic>
References: <8484013.LsABBJRIOx@devpool02>
 <24155824.fdsQYPMaDK@donald.sf-tec.de>
 <20130811083718.GA9461@pd.tnic>
 <2220835.PTjEcfuM0P@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2220835.PTjEcfuM0P@donald.sf-tec.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 01:10:11PM +0200, Rolf Eike Beer wrote:
> The RAM seems fine. It looks like it is the mainboard or a harddisk.
> The issues have magically disappeared since 3 weeks, but I have not
> done any suspend2disk since then anymore. Before that I had suspended
> the machine on the evening and resumed when I came to work. So it's
> possible that there was some corrupted stuff in the image.

Hmm, probably...

> This is the smart output I got of one disk yesterday:
> 
> Vendor:               /0:0:0:0
> Product:
> User Capacity:        600,332,565,813,390,450 bytes [600 PB]

Is this for real? 600 PB??

I wanna hdd like that :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

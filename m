Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab3HML5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:57:41 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:35540 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab3HML5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:57:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Aug 2013 13:57:36 +0200
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        <dhowells@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Hard lockups using 3.10.0
In-Reply-To: <20130813103808.GA4077@pd.tnic>
References: <8484013.LsABBJRIOx@devpool02>
 <24155824.fdsQYPMaDK@donald.sf-tec.de> <20130811083718.GA9461@pd.tnic>
 <2220835.PTjEcfuM0P@donald.sf-tec.de> <20130813103808.GA4077@pd.tnic>
Message-ID: <45d8cfa5eef633532b25c36b0bffa12c@sf-mail.de>
User-Agent: Roundcube Webmail/0.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Sun, Aug 11, 2013 at 01:10:11PM +0200, Rolf Eike Beer wrote:
>> The RAM seems fine. It looks like it is the mainboard or a harddisk.
>> The issues have magically disappeared since 3 weeks, but I have not
>> done any suspend2disk since then anymore. Before that I had suspended
>> the machine on the evening and resumed when I came to work. So it's
>> possible that there was some corrupted stuff in the image.
> 
> Hmm, probably...
> 
>> This is the smart output I got of one disk yesterday:
>> 
>> Vendor:               /0:0:0:0
>> Product:
>> User Capacity:        600,332,565,813,390,450 bytes [600 PB]
> 
> Is this for real? 600 PB??
> 
> I wanna hdd like that :-)

We have problems getting such a disk again. Seems all available one 
have disappeared somewhere near Bluffdale.

I'm not sure how good ext4 can handle sector sizes of several hundred 
megabytes, so it may be not that fun ;)

Eike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3AQSpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:45:21 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:58176 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814Ab3AQSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:45:19 -0500
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 13:45:19 EST
X-Panda: scanned!
X-Session-Marker: 6A61736F6E40776172722E6E6574
X-Filterd-Recvd-Size: 2517
Message-ID: <50F844A3.9020300@warr.net>
Date: Thu, 17 Jan 2013 12:36:19 -0600
From: Jason Warr <jason@warr.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Amit Kale <akale@stec-inc.com>
CC: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/17/2013 11:53 AM, Amit Kale wrote:
>>> 9. Performance - Throughput is generally most important. Latency is
>> >   also one more performance comparison point. Performance under
>> >   different load classes can be measured.
>> > 
>> >   I think latency is more important than throughput.  Spindles are
>> >   pretty good at throughput.  In fact the mq policy tries to spot when
>> >   we're doing large linear ios and stops hit counting; best leave this
>> >   stuff on the spindle.
> I disagree. Latency is taken care of automatically when the number of application threads rises.
>

Can you explain what you mean by that in a little more detail?

As an enterprise level user I see both as important overall.  However,
the biggest driving factor in wanting a cache device in front of any
sort of target in my use cases is to hide latency as the number of
threads reading and writing to the backing device go up.  So for me the
cache is basically a tier stage where your ability to keep dirty blocks
on it is determined by the specific use case.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaBSB2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:28:52 -0500
Received: from nm34.bullet.mail.ne1.yahoo.com ([98.138.229.27]:29159 "EHLO
	nm34.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbaBSB2u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:28:50 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 388899.92139.bm@omp1022.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ENwI08vqjqtl5uG+z4Y/OX80LQiswZCVJEErARYR9liPgUdCMmFUiWY+mFiXC8tFRLkBPzvHN26Qh9joxa9OKZDaWQ0r5pwxS+eTVjzJa1u2YbY1+yzI5jU7+riEGTlCAQcUAsrNlW0T18FYrAqWg7mh644iEyivHsYQintbn5k=;
X-YMail-OSG: BPv4KokVM1nPMDcViNg0J7CKJsoTP_RHxCniX7L_75MzAZb
 qRSJj0nJoqt1XPOdzh3pM.sdZKbByXnZuhqK9DQgvTyyKg4CfHN2s3BoJ88o
 jz8crM1_q4_.Ma461h5xdLIGXBM55fQIDkXYzINezVsZBTKctqiUuXOoyfX.
 ooxuY4SmpeLxYU9447dEXeime6v.DGMpt4mHeRZW_AlSOnxxATiqbiPhmG33
 pQlB2ni7ZWTSynLjvIYtNpLKSjayn6fWd4O.boLjJLfTZ3gQ71TWtO5hcmJF
 ACU4_bgzVJYb9z4H77XqgB7avOMVZkNxG4i0aOUlyHlHqTT35Qoxb55.BzOe
 8PEaSd88ZycmXGxPxS1tFfd63V2T4gY9XD9mAFpTf_cHkxEdBHNQrRxM9Cbr
 kDp5j16V75D3ByCn.r3lmjJsagLZRIpQQxnPORTqnwqRA6FU5FWjotknqKKt
 zBy2Ce12ErFw3m45s8nkrC5MwHeZ59B7ylBqC65VLLAELZF9jiy_XGJa693l
 pOLyyQRTHjjIccZCrii4Fv1SS3QiaRRvhkN0-
X-Rocket-MIMEInfo: 002.001,Cgo.T24gVHVlc2RheSwgRmVicnVhcnkgMTgsIDIwMTQgNTowMCBBTSwgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPiB3cm90ZToKCj4.T24gTW9uLCBGZWIgMTcsIDIwMTQgYXQgMTI6NDU6MDdQTSAtMDgwMCwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.Pj5PbiBNb25kYXksIEZlYnJ1YXJ5IDE3LCAyMDE0IDc6MTYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKPj4.Pgo.Pj4.T24gMjAxNC0wMi0xNiAwODo0MCwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgoBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <53020B92.6060805@mev.co.uk> <1392669907.92125.YahooMailNeo@web164001.mail.gq1.yahoo.com> <20140218105944.GM26722@mwanda>
Message-ID: <1392773159.94094.YahooMailNeo@web164004.mail.gq1.yahoo.com>
Date: Tue, 18 Feb 2014 17:25:59 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: fix brace-related coding style issues in hwdrv_apci035.c
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140218105944.GM26722@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>On Tuesday, February 18, 2014 5:00 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

>>On Mon, Feb 17, 2014 at 12:45:07PM -0800, Chase Southwood wrote:
>>>On Monday, February 17, 2014 7:16 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>>>
>>>>On 2014-02-16 08:40, Chase Southwood wrote:
>>>> This patch for hwdrv_apci035 removes some unneeded braces, and moves some
>>>> improperly placed braces to the correct position, as found by checkpatch.
>>>> It also removes a commented out if-statement that I found whilst cleaning
>>>> braces that is identical to another un-commented if-statement directly
>>>> above it, so it is just added clutter and so we can delete it to clean up
>>>> further.
>>>>
>>>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>>> ---
>>>> So I decided to venture into addi-data today and found that most of the
>>>> files in there are very messy from a style standpoint.  This is the first
>>>> (of probably a few) patchsets to try and clean those files up a bit.  I
>>>> hope that this will be helpful!
>>>>
>>>Quite a few have been cleaned up extensively by Hartley, but they needed 
>>>more extensive changes than clean-ups due to them trying to handle 
>>>things differently to the normal comedi way of doing things.
>>
>>Oh, I see.  Makes perfect sense.  Well like I said, if cleaning them
>>up a bit will help make reworking them any easier or seems like useful
>>work, I'd be happy to continue making them a little easier on the
>>eyes!
>
>Ian acked your patch already...  If you want to clean these up then go
>for it.  There is no reason Hartley should have to do all the work.
>
>But consider doing more "extensive" cleanups.  Instead of just shifting
>the comments over in [patch 2/4] you could change the format to kernel
>style.  Newbies are too timid.  Look through the work that Hartley has
>done and try copy it.
>
>regards,
>dan carpenter

Dan,

I appreciate the feedback on my contributions.  I will try to do more extensive cleaning because I want to help out as best as I can.

Thanks,
Chase


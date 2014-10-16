Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaJPN1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:27:43 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40174 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbaJPN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:27:42 -0400
Message-ID: <543FC7CB.4060601@hurleysoftware.com>
Date: Thu, 16 Oct 2014 09:27:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Div-by-zero in the 8250 serial driver (3.17-rc5)
References: <CAP145pg75hFKi2S9SVywRfex_A5=yRpe0p4Dzri8+Q=7YWoXfg@mail.gmail.com> <541C27E8.6090000@hurleysoftware.com> <543FC31E.3000702@hurleysoftware.com> <20141016131901.GA5501@kroah.com>
In-Reply-To: <20141016131901.GA5501@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 09:19 AM, Greg KH wrote:
> On Thu, Oct 16, 2014 at 09:07:42AM -0400, Peter Hurley wrote:
>> Hi Greg,
>>
>> I noticed this patch didn't make it into 3.18-rc1 or -next.
>> Do I need to resend this?
> 
> Ugh, sorry about that, I think it got buried in the thread.  Please
> always resend things like this in a patch-form that I can apply it
> without having to edit the email by hand.

Ok. I guess for some reason I thought that your scripts scissored
automatically. Will do for the future.

> So yes, please resend, I'll get it into an early -rc release.  And is
> this needed for 3.17-stable and prior?

Yes, for all -stable. I'll cc stable in the resend.

Regards,
Peter Hurley


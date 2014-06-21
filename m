Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaFUNG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:06:26 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33979 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaFUNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:06:25 -0400
Message-ID: <53A5834F.8050805@lwfinger.net>
Date: Sat, 21 Jun 2014 08:06:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        pebolle@tiscali.nl, Himangi Saraogi <himangi774@gmail.com>,
        Konrad Zapalowicz <bergo.torino@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in halbcoutsrc
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>	<20140620195926.GY5500@mwanda>	<1403294880.4076.7.camel@joe-AO725>	<CAPDOMVi2humH7sL8DDkY=WJ3gWnehdeX8QEnNf6d8oTWftHXKA@mail.gmail.com>	<1403318075.4076.31.camel@joe-AO725> <CAPDOMVgyttC0AY8CUbWESSBKpkskJYjC3L1AcPw_s0q=QJjLoQ@mail.gmail.com>
In-Reply-To: <CAPDOMVgyttC0AY8CUbWESSBKpkskJYjC3L1AcPw_s0q=QJjLoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:52 PM, Nick Krause wrote:
> Is this patch being merged or is this not an issue. I am confused
> did I make a mistake in my patch or is there being a different
> patch being merged.
> Thank Nick
>
> On Fri, Jun 20, 2014 at 10:34 PM, Joe Perches <joe@perches.com> wrote:
>> On Fri, 2014-06-20 at 22:26 -0400, Nick Krause wrote:
>>> Thanks for the feedback I will resend the patch fixed.
>>
>> Please do not.
>>
>>> Otherwise please use Larry's idea.
>>
>> It's not Larry's idea.  Larry is the primary
>> contributor for Realtek drivers in staging.

I have just returned from back-to-back trips and a recovery from the failure of 
my primary laptop. Once I get a little time, I will research this issue and let 
you know. In the meantime, this patch should not be merged as it is not likely 
correct.

Larry



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaFAWKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 18:10:39 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41541 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFAWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 18:10:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140601235017.289a8d4b@spike>
References: <1401622340-13453-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140601235017.289a8d4b@spike>
Date: Mon, 2 Jun 2014 00:10:37 +0200
Message-ID: <CAFo99gb6xOOezVpDQJ9uP1EkvpZ8Z-CWNMPrOby8zRo+7+motA@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8712: rtl871x_mlme.c: Cleaning up memory leak
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Cort <linuxgeek@gmail.com>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian!

Yes!  I mail about this for the first time in early May, but ther were
many other faults in the design of my patch, had several different
types of errors in the same path etc.

So good that they have already been solved then :)



Best regards
Rickard Strandqvist


2014-06-01 23:50 GMT+02:00 Christian Engelmayer <cengelma@gmx.at>:
> On Sun,  1 Jun 2014 13:32:20 +0200, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>> There is a risk for memory leak in when something unexpected happens
>> and the function returns.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> This doesn't apply against staging-next. This fix seems to attack the same
> problem as existing commit 2af9e74 (staging: rtl8712: fix potential leaks in
> r8712_set_key()) - http://www.spinics.net/lists/linux-driver-devel/msg46501.html
>
> I think we talked about that already - see
> http://www.spinics.net/lists/linux-driver-devel/msg46294.html
>
> Regards,
> Christian

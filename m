Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaBKFh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 00:37:28 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60758 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaBKFhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 00:37:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140209163142.GB11774@kroah.com>
References: <1391936386-2890-1-git-send-email-raymond.wanyoike@gmail.com>
	<20140209163142.GB11774@kroah.com>
Date: Tue, 11 Feb 2014 08:37:21 +0300
Message-ID: <CAJ9+zUuCiLGkH1CuB6jtw5+SvtfXhubvAiikAC3hxO=BQxO2Lg@mail.gmail.com>
Subject: Re: [RFC] usb: option: blacklist ZTE MF667 net interface
From: Raymond W <raymond.wanyoike@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, first time, meant to be "PATCH".

On Sun, Feb 9, 2014 at 7:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Feb 09, 2014 at 11:59:46AM +0300, Raymond Wanyoike wrote:
>> Interface #5 of 19d2:1270 is a net interface which has been submitted to the
>> qmi_wwan driver so consequently remove it from the option driver.
>>
>> Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>
>> ---
>>  drivers/usb/serial/option.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Why is this patch a "RFC"?



-- 
Raymond

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaK2SyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 13:54:22 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47534 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK2SyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 13:54:20 -0500
Message-ID: <547A1659.9070605@lwfinger.net>
Date: Sat, 29 Nov 2014 12:54:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] drivers:net:wireless: Add mutex locking for function,
 b43_op_beacon_set_time in main.c
References: <1417213013-19758-1-git-send-email-xerofoify@gmail.com>	<CACna6rxmOC0h9hOpa=5iWFM1THQ8Q4hCi8MnmqkZJbB_U0PJ0A@mail.gmail.com>	<20141129002148.1beb21d9@wiggum>	<54793E4E.7050602@gmail.com>	<20141129095632.69361457@wiggum> <CACna6ryjZ-LY06wAMzoL77Wca3McUUT+VYsO4EPO87NqjBnaNw@mail.gmail.com> <547A0BC5.2080005@gmail.com>
In-Reply-To: <547A0BC5.2080005@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2014 12:09 PM, nick wrote:
> Sorry about that, next time I will be more careful.

One other thing would be to change the initial part of the subject. Yes, the 
device is in drivers/net/wireless/, but it is much more common to not include 
those in patches that are sent to Linville. I would have used "b43: Add ...". 
That catches the eye more quickly. As they say in the newspaper business, "Don't 
bury the lead."

Larry



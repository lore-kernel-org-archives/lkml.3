Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaJKRmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:42:05 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49966 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaJKRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:42:01 -0400
Message-ID: <54396BE0.90500@gmail.com>
Date: Sun, 12 Oct 2014 00:41:52 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jonas Brunsgaard <jonas.brunsgaard@gmail.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: atm: fix codestyle issues in
References: <1413043368-24548-1-git-send-email-jonas.brunsgaard@gmail.com> <5439621C.20405@gmail.com> <CACVXvXq_iq0Jq56536zNtKudGqf6qsPqjc7sC-io6aUGJ=AvGA@mail.gmail.com>
In-Reply-To: <CACVXvXq_iq0Jq56536zNtKudGqf6qsPqjc7sC-io6aUGJ=AvGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-12 00:28, Jonas Brunsgaard wrote:
> Could you be more specific, what is it you dislike? After this patch
> the checkpatch script only come up with a couple of warnings, all due
> to the line length limit, and these warnings are all acceppable as
> they improve the ability to grep for user readable strings.
Yes it was the many long lines I had in mind, seems I am the one who 
have to read up on that rule exception.

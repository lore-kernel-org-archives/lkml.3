Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBMVsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:48:50 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:36591 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBMVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:48:49 -0500
Message-ID: <52FD3DB5.303@ahsoftware.de>
Date: Thu, 13 Feb 2014 22:48:37 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Marcel Holtmann <marcel@holtmann.org>
CC: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/24] rfcomm fixes
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <52F95A10.5010507@hurleysoftware.com> <433F6D97-A126-4F9F-96AC-4385575E005E@holtmann.org> <52FC13F0.8040809@hurleysoftware.com>
In-Reply-To: <52FC13F0.8040809@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.02.2014 01:38, schrieb Peter Hurley:
> Hi Marcel,
>
> On 02/12/2014 05:58 PM, Marcel Holtmann wrote:
>> we might also want to add some end-to-end test cases to rfcomm-tester
>> that covers this behavior.

Sounds great. Such would have found the problem with disappearing remote 
bt (rfcomm) devices since 3.8 likely earlier than I did (which was 
around 3.10 if I remember correctly).

Regards,

Alexander Holler

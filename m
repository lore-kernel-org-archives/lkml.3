Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaCPAQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 20:16:44 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56820 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbaCPAQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 20:16:42 -0400
MIME-Version: 1.0
In-Reply-To: <5324BBCF.1090101@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
	<3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
	<1259174563.20140212120644@eikelenboom.it>
	<1335661753.20140303203853@eikelenboom.it>
	<1295963563.20140310093843@eikelenboom.it>
	<20140310150858.GA25703@tuxdriver.com>
	<EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org>
	<1679354302.20140314014901@eikelenboom.it>
	<53225B87.1030904@hurleysoftware.com>
	<164289036.20140315145146@eikelenboom.it>
	<CA+55aFzLGvLhF258vCWbyvXX0UOJ_tcnKaNRz_38mR5rnO6e_Q@mail.gmail.com>
	<5324BBCF.1090101@hurleysoftware.com>
Date: Sat, 15 Mar 2014 17:16:41 -0700
X-Google-Sender-Auth: yQ1amrbHZ7WWH0pxnkROhVBk29E
Message-ID: <CA+55aFy6xfK3ZAUA-HRx-SPi2b7ZWMonF-MHp=SdOa-gX2jthg@mail.gmail.com>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 1:45 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>
> FWIW, the 'known breakage' for 3.14 is a (valid) lockdep report.

Ok, if it's just lockdep and unlikely to hit in real life and getting
fixed later, I guess I don't really care all that deeply for 3.14

                  Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBCHKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:10:30 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48667 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaBCHK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:10:29 -0500
Message-ID: <52EF40E1.3090003@gmail.com>
Date: Mon, 03 Feb 2014 08:10:25 +0100
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 3.14-rc1 is out
In-Reply-To: <CA+55aFyTzEjZiWK+B7cZj=0q-GsDPK372CK2a+F02OXnCeBsYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is that OK/wanted to note a possibly wide regression as Reply-To in the 
announce thread?

If your USB 3.0 stopped working with 3.14-rc1, please note it's already 
tracked regression reported in:
xhci regression since "xhci: replace xhci_write_64() with writeq()" - 
devices not detected

http://www.spinics.net/lists/linux-usb/msg101628.html
http://comments.gmane.org/gmane.linux.usb.general/102295

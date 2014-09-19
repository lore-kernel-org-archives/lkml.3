Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbaISTSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:18:10 -0400
Received: from fep16.mx.upcmail.net ([62.179.121.36]:54531 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbaISTSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:18:09 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <541C7958.7050603@odi.ch>
Date: Fri, 19 Sep 2014 20:43:36 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
References: <541AE737.8070009@odi.ch>	<CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>	<541C40AA.4060206@odi.ch>	<CAKb7Uvjm7vFxd-aTtuh4=XE-4JONRJgAt8n93vDHZnARsg+yiw@mail.gmail.com>	<541C5F6A.1040006@odi.ch> <CAKb7Uvi_BN5WZPUA55Ma_2i5nQceryrnjJW54tCXU1hm0KVC4w@mail.gmail.com>
In-Reply-To: <CAKb7Uvi_BN5WZPUA55Ma_2i5nQceryrnjJW54tCXU1hm0KVC4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 07:01 PM, Ilia Mirkin wrote:
> Thanks! Hopefully you still have those kernels handy, as your logs got
> cut off.

Yeah, I noticed and hoped it wouldn't matter as it is mostly the boot log that's 
been cut off until syslog came up (it's from /var/log/messages). So 
suspend/resume cycle should be complete. But I can give it another try on Monday 
when I'm back in the office.

Ortwin

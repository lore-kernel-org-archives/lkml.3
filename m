Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaISOmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:42:13 -0400
Received: from [62.179.121.43] ([62.179.121.43]:44928 "EHLO
	fep23.mx.upcmail.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756805AbaISOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:42:10 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <541C40AA.4060206@odi.ch>
Date: Fri, 19 Sep 2014 16:41:46 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
References: <541AE737.8070009@odi.ch> <CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>
In-Reply-To: <CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18.09.2014 16:58, Ilia Mirkin wrote:
> This has been reported a few times already -- probably the same thing
> as bug https://bugs.freedesktop.org/show_bug.cgi?id=83550

Ah, thanks. I would like to try with that commit reverted, but unfortunately it no longer reverts
cleanly, and my attempts to make a sensible merge were futile. If you can send me a patch that
reverts the changes on 3.17-rc5 or 3.16 I am glad to try it out and give you the requested feedback.

Ortwin

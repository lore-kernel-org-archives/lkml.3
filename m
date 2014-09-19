Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaISQxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:53:34 -0400
Received: from [62.179.121.32] ([62.179.121.32]:42690 "EHLO
	fep12.mx.upcmail.net" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756553AbaISQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:53:33 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <541C5F6A.1040006@odi.ch>
Date: Fri, 19 Sep 2014 18:52:58 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: Re: [BUG] nouveau regression: ext monitor dead after resume
References: <541AE737.8070009@odi.ch>	<CAKb7UvjcYsFm7TWzKXdWHVDVRDO1rFtcCTZoChYssDKqLMDGWw@mail.gmail.com>	<541C40AA.4060206@odi.ch> <CAKb7Uvjm7vFxd-aTtuh4=XE-4JONRJgAt8n93vDHZnARsg+yiw@mail.gmail.com>
In-Reply-To: <CAKb7Uvjm7vFxd-aTtuh4=XE-4JONRJgAt8n93vDHZnARsg+yiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2014 17:58, Ilia Mirkin wrote:
> git checkout 415f12efc1b2308411b2cbc3e82666b3db8a7758^

Thanks again. I confirm that Bugzilla 83550 is the same issue. I have attached the captured logs
there for reference.

Ortwin

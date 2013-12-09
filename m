Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495Ab3LIVkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:40:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36916 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3LIVkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:40:12 -0500
Message-ID: <52A6389E.90404@zytor.com>
Date: Mon, 09 Dec 2013 13:39:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz> <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
In-Reply-To: <CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:03 PM, H.J. Lu wrote:
> 
> No, please don't do that.  Normally, PIE has zero load address and kernel
> can load it anywhere.  There are multiple reasons why PIE has non-zero
> load address.  Saying you need to load a program above 4GB under x86-64,
> you can't do that with normal dynamic executable.  PIE with non-zero load
> address is the only way to do that on x86-64.
> 

Why does it have to be PIE?

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3LIVtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:49:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37016 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3LIVtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:49:23 -0500
Message-ID: <52A63AD4.2030101@zytor.com>
Date: Mon, 09 Dec 2013 13:49:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz> <CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
In-Reply-To: <CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
>> PT_LOAD being non-zero causing randomization to be turned off seems like
>> quite unexpected behavior to me, with a great potential to cause a lot of
>> confusion.
> 
> There should be no difference between dynamic executable and PIE
> with non-zero vaddr when choosing where to load them.
> 

Why is that?  It would seem to be a big difference between a relocatable
binary (PIE) and one with a load address fixed at link time.

	-hpa


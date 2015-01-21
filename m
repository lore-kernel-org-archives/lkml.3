Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbbAUWvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:51:38 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:58059 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:51:29 -0500
Date: Wed, 21 Jan 2015 14:51:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: WANG Chao <chaowang@redhat.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pavel Machek <pavel@ucw.cz>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Xishi Qiu <qiuxishi@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, e820: clean up around sanitize_e820_map()
In-Reply-To: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
Message-ID: <alpine.DEB.2.10.1501211450330.2716@chino.kir.corp.google.com>
References: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, WANG Chao wrote:

> The argument 3 of sanitize_e820_map() will only update upon a successful
> sanitization. Some of the callers may not be aware of this in the past.
> Now clean up these callers.
> 
> Signed-off-by: WANG Chao <chaowang@redhat.com>

Nice, but it's incomplete: it should also cleanup 
default_machine_specific_memory_setup().  After that's fixed, feel free to 
add my

	Acked-by: David Rientjes <rientjes@google.com>

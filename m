Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaAHWkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:40:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312AbaAHWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:40:29 -0500
Message-ID: <52CDD3AE.4030301@zytor.com>
Date: Wed, 08 Jan 2014 14:39:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: halfdog <me@halfdog.net>, Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net> <52C31027.2030101@zytor.com> <20131231192106.GA22535@phenom.dumpdata.com> <52C347F0.8070902@zytor.com> <52CD022E.9040107@halfdog.net> <52CD8E10.3010204@zytor.com> <20140108193655.GD5098@pd.tnic> <52CDC316.4050503@halfdog.net>
In-Reply-To: <52CDC316.4050503@halfdog.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is obviously critical here that we get a handle on if this is a
CPU-specific problem that we might have to work around or a general
problem with the Linux code.

	-hpa

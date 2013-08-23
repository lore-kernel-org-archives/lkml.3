Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3HWTH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:07:59 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:41503 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3HWTH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-899f1812-2208-4b01-ab7e-05b7e4304ac6-1377281890307@3capp-gmx-bs52>
References: <trinity-899f1812-2208-4b01-ab7e-05b7e4304ac6-1377281890307@3capp-gmx-bs52>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 Aug 2013 12:07:36 -0700
Message-ID: <CALCETrW4MG7j-30B2fw4DCJqkqTdtqRCMpCqDL06qzcN0BMKoA@mail.gmail.com>
Subject: Re: Re: Re: question about ioremap_cache and PAT
To: Andreas Werner <wernerandy@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 11:18 AM, Andreas Werner <wernerandy@gmx.de> wrote:
> Hi,
>
> why are you curious?
>
> I have never heard about movntdqa. Have you ever tried it?
> May be it is a good idea to try i out.

I've never tried it, but in theory it should be comparably fast as
compared to WT.

--Andy

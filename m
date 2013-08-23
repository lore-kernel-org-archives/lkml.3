Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3HWVLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:11:01 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38311 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3HWVLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-ffa0da23-5491-4202-851d-c3a1cb076276-1377281052905@3capp-gmx-bs14>
References: <trinity-ffa0da23-5491-4202-851d-c3a1cb076276-1377281052905@3capp-gmx-bs14>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 Aug 2013 14:10:39 -0700
Message-ID: <CALCETrX++yz7GifsR=jmnD0_MJUxTdh5d7WHDYXZnvx9ZP+Z8g@mail.gmail.com>
Subject: Re:
To: Andreas Werner <wernerandy@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 11:04 AM, Andreas Werner <wernerandy@gmx.de> wrote:
> Hi,
>
> why are you curious?
>
> I have never heard about movntdqa. Have you ever tried it?
> May be it is a good idea to try i out.

It seems less fragile than playing games with memory types to get
streaming loads without causing MCEs.

--Andy

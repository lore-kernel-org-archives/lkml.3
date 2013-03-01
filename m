Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3CAK5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:57:12 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46972 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CAK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:57:10 -0500
Date: Fri, 1 Mar 2013 11:57:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: change names of e820 memory map type
Message-ID: <20130301105705.GA2625@gmail.com>
References: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com>
 <f5d7ca6f-7d88-4acd-9571-a48ed1097f75@email.android.com>
 <1362129067.2262.84.camel@liguang.fnst.cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362129067.2262.84.camel@liguang.fnst.cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* li guang <lig.fnst@cn.fujitsu.com> wrote:

> gratuitous?
> 
> It was inspired by gtk library's key definitions,

I don't think GTK is a shining example of API cleanliness and usability that the 
kernel should strive to imitate, especially not in the naming department...

> gtk original keys like GDK_1, GDK_2, GDK_p, GDK_q, GDK_tab ...
> now they all be changed to GDK_KEY_1, GDK_KEY_2 ...
> do you think it's reasonable?
> or gratuitous?

I think hpa already expressed his opinion about the rename?

Thanks,

	Ingo

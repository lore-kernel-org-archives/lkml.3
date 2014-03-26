Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbaCZTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:03:50 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:24481 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbaCZTDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:03:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgINAH0jM1NXQ457/2dsb2JhbABZgwaCSYEVwCIEAoEcF3SCJQEBAQMBOhwjBQsIA0Y5HgYTh3EMAdEIF45xB4Q4AQOYTAGKWodZgXCBPzw
Date: Wed, 26 Mar 2014 20:03:47 +0100
From: Fabian Frederick <fabf@skynet.be>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ufs] WARNING: CPU: 0 PID: 483 at
 kernel/locking/mutex-debug.c:117 mutex_destroy()
Message-Id: <20140326200347.f9b040cdd4dbbe4ba189ecb8@skynet.be>
In-Reply-To: <20140326142646.GA26473@localhost>
References: <20140326142646.GA26473@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 22:26:46 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Greetings,
> 
> I got the below dmesg and the first bad commit is

Thanks a lot ! I hope the fix I sent you will be ok :)

Regards,
Fabian

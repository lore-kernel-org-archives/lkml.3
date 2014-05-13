Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaEMTB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:01:58 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:51589 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594AbaEMTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:01:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuofAERrclNbtADP/2dsb2JhbABZgwaCQao7AQEBAQEBBQGaEwEDAgIBAQGBIhd0giUBAQQBOhwjBQsIAw44IRgeBhOILQMJDAHAMA2GVBeFVIZlghUHhEABA5ddgXIBiwuCHIVpgzg7
Date: Tue, 13 May 2014 21:01:46 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Steve French <smfrench@gmail.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [PATCH 1/1] fs/cifs/cifs.c: replace seq_printf by seq_puts
Message-Id: <20140513210146.f556f111de66c14738b5890b@skynet.be>
In-Reply-To: <CAH2r5msidCDwgBunwNKjrDEhL9-3f5ZkkxezPVsUfctvQEuADA@mail.gmail.com>
References: <20140513180417.74af95e95649ba975d53badb@skynet.be>
	<CAH2r5msidCDwgBunwNKjrDEhL9-3f5ZkkxezPVsUfctvQEuADA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 20:48:09 +0200
Steve French <smfrench@gmail.com> wrote:

> merged into cifs-2.6.git for-next
> 
> Is the goal here to replace seq_printf (everywhere it has fixed number
> of arguments) with seq_puts (it saves a few lines of code since in
> those cases seq_printf will turn around and simply call seq_puts)?
Hi Steve,

   Exactly. Those were some checkpatch warnings asking for conversion.

Fabian

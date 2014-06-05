Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaFEGzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 02:55:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFEGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 02:55:45 -0400
Date: Wed, 04 Jun 2014 23:55:41 -0700 (PDT)
Message-Id: <20140604.235541.751933005917980567.davem@davemloft.net>
To: dborkman@redhat.com
Cc: chema@google.com, ast@plumgrid.com, mingo@kernel.org, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, acme@infradead.org, jolsa@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        keescook@chromium.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 net-next 1/4] net: flow_dissector: avoid multiple
 calls in eBPF
From: David Miller <davem@davemloft.net>
In-Reply-To: <538EDE1A.8060305@redhat.com>
References: <CAMEtUuxK5hV_eORRLaSHSiwF5X82Ae91vL6W0-6au48v8H6bAA@mail.gmail.com>
	<CA+ZOOTPdDDeGxZVGXVRZmjkxqkGefgDLrawo_9YXbjwTQ_FLzA@mail.gmail.com>
	<538EDE1A.8060305@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Jun 2014 23:55:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW, I'm not applying this series.

There is no real consensus and a lot more discussion and time is
needed before anything happens here.

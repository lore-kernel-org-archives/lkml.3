Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaEWT2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:28:05 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62911 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaEWT2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:28:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] ARM: trusted_foundations: fix compile error on non-SMP
Date: Fri, 23 May 2014 21:27:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org
References: <1400804612-11876-1-git-send-email-acourbot@nvidia.com> <537F9267.7090304@cogentembedded.com>
In-Reply-To: <537F9267.7090304@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405232127.56481.arnd@arndb.de>
X-Provags-ID: V02:K0:MOauhNoQN3kTJJmq8TG+EqoPflpp2wJOGmgXDqwI5e0
 vykKXQ+1xRQp5YzbgkoW1AXRb2H+oXk76pSDVrChUHhOawgsak
 Qr+URJNo7mOM1dwE8FCSnhJ/UZY0+kxXzB8ZCQCGqkHrIkd+hi
 kp4/AaYNtgVUMtHzCRh2xA2rcJzsXARoBl8VZnipT0bEuYbO0n
 39lZTyKcaezQ9uFn14TrIxrGIviMhmtsY+wsovMGOlgX9eK2oN
 yRWViW1LJ+ivEYhgjrCJE3OggNo+wTJxBR0Hne1mDv2B1Sx4aq
 IMQ0v5BwL9J1oatc7DZpqvqDhahCF0A6CKpQSYcDgAwJi1in0t
 mViZ1rZ1Oqosu8KPJ9eM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014, Sergei Shtylyov wrote:
> > +#if IS_ENABLED(CONFIG_SMP)
> 
>         if (IS_ENABLED(CONFIG_SMP))
> 
> >       setup_max_cpus = 0;
> > +#endif
> 

That wouldn't help to fix the build error when setup_max_cpus is not declared.

	Arnd

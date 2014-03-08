Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaCHD1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:27:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaCHD1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:27:32 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eparis@redhat.com, ebiederm@xmission.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket buffer is large enough
Date: Fri, 07 Mar 2014 22:27:28 -0500
Message-ID: <5147229.ivUnbSCGlH@x2>
Organization: Red Hat
User-Agent: KMail/4.12.2 (Linux/3.13.5-202.fc20.x86_64; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140307.194801.1893514114998807038.davem@davemloft.net>
References: <7457128.6VP2v68V93@x2> <1394232722.17779.57.camel@flatline.rdu.redhat.com> <20140307.194801.1893514114998807038.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 07, 2014 07:48:01 PM David Miller wrote:
> From: Eric Paris <eparis@redhat.com>
> Date: Fri, 07 Mar 2014 17:52:02 -0500
> 
> > Audit is non-tolerant to failure and loss.
> 
> Netlink is not a loss-less transport.

Perhaps. But in all our testing over the years its been very good.

-Steve

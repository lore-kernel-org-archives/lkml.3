Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3HANFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:05:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32558 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3HANFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:05:00 -0400
Message-ID: <51FA5CD8.2090807@oracle.com>
Date: Thu, 01 Aug 2013 08:04:24 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130801085831.GA21552@infradead.org>
In-Reply-To: <20130801085831.GA21552@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 03:58 AM, Christoph Hellwig wrote:
> What should be added to this support is to move the swap over nfs code
> over to this interface instead of the utterly bogus
> KERNEL_READ/KERNEL_WRITE hacks that were added for it.

That's patch 24/33 nfs: simplify swap

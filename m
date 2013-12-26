Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3LZTOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:14:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45632 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3LZTOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:14:08 -0500
Message-ID: <52BC7FE1.6070508@zytor.com>
Date: Thu, 26 Dec 2013 11:13:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t/__kernel_ulong_t in <linux/resource.h>
References: <20131225145447.GA18146@gmail.com>	<20131226100348.GA7751@infradead.org> <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
In-Reply-To: <CAMe9rOqx1HDT_rtiz2R0Cz5iAp0AFXhjw6RpTkjgFT_DDDWfVA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 05:52 AM, H.J. Lu wrote:
>>
>>  a) please send all your related patches as a series
> 
> My patches are independent of each other.  They can
> be applied in order.
> 

Sure, but the convention in the Linux community is to send them all as a
"series" using git send-email, preferably with a introductory cover
letter as the "0/N patch" so they arrive in a single thread and can be
reviewed together.  Otherwise bits tend to get lost in the enormous
flood of email that is LKML.

	-hpa



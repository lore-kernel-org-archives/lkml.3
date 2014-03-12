Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaCLQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:16:26 -0400
Received: from smtp03.stone-is.org ([87.238.162.6]:44002 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaCLQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:16:22 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53208851.8080103@acm.org>
Date: Wed, 12 Mar 2014 17:16:17 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
References: <531DC851.5060400@acm.org> <20140311135137.GA22995@dhcp-26-207.brq.redhat.com> <531F518A.1070808@acm.org> <20140311204826.GA30105@dhcp-26-207.brq.redhat.com> <53200B2E.4060805@acm.org> <20140312152140.GA14305@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140312152140.GA14305@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 16:21, Alexander Gordeev wrote:
> While 'remote->nr_free' could be dropped on another CPU it still does not
> explain how steal_tags() enters the loop, but fails to locate 'cpus_have_tags'
> count of bits.
> 
> So although v2 of your patch fixes the crash it does not address the root
> cause IMHO.

Hmm ... you are probably right. I will analyze this further and see what
I can come up with.

Bart.


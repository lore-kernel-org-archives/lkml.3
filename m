Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935311AbaGXX2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935045AbaGXX2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:28:08 -0400
Message-ID: <53D19682.5040400@redhat.com>
Date: Fri, 25 Jul 2014 01:28:02 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: filter: rename 'struct sock_filter_int'
 into 'struct bpf_insn'
References: <1406237179-3713-1-git-send-email-ast@plumgrid.com> <53D194F1.6020603@redhat.com> <CAMEtUuxHp5QzWQ+DhMPiNWDH6LxWPjgincK=Sk8xeJjivieY0w@mail.gmail.com>
In-Reply-To: <CAMEtUuxHp5QzWQ+DhMPiNWDH6LxWPjgincK=Sk8xeJjivieY0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 01:26 AM, Alexei Starovoitov wrote:
...
> you mean to align last \ with other lines?
> sure. good point.

Yeah, would be good. Otherwise looks good, of course.

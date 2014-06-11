Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaFKKdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:33:40 -0400
Received: from mail.datacast.hu ([195.70.49.210]:52953 "EHLO mail.datacast.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbaFKKda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:33:30 -0400
Message-ID: <53983074.6010800@egervary.hu>
Date: Wed, 11 Jun 2014 12:33:24 +0200
From: =?ISO-8859-15?Q?Egerv=E1ry_Gergely?= <gergely@egervary.hu>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, stable@kernel.org
Subject: Re: 3.4.92 MTU issues
References: <53975FF9.5070803@egervary.hu> <CAADnVQ+q3wFf=j0TY57d6Ux4GyGLr0bVCFHDgA45n9rXiEEzjg@mail.gmail.com> <20140610213722.GE1970@breakpoint.cc>
In-Reply-To: <20140610213722.GE1970@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -stable lacks commit 895162b1101b3ea5db08ca6822ae9672717efec0, so
> netfilter never sets ->local_df.  Thus all defragmented packets
> that go over the mtu are refused to be forwarded.

Thank you for your quick response. Should we expect a 3.4.93 release
with this issue fixed in a few days?

-- 
Gergely EGERVARY
Network Administrator

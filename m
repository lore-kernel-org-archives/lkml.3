Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaGYXVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:21:51 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:52506 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaGYXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <1406306339-16151-1-git-send-email-mypopydev@gmail.com>
References: <1406306339-16151-1-git-send-email-mypopydev@gmail.com>
Date: Fri, 25 Jul 2014 16:21:48 -0700
Message-ID: <CAHA+R7Nq1iZfLzUa+WY4=y33dna7PuN7cU0z5opRwZPsqeuznQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] neighbour : fix ndm_type type error issue
From: Cong Wang <cwang@twopensource.com>
To: Jun Zhao <mypopydev@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen hemminger <stephen@networkplumber.org>,
        Tom Herbert <therbert@google.com>, netdev <netdev@vger.kernel.org>,
        Francesco Fusco <ffusco@redhat.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Jiri Pirko <jiri@resnulli.us>, David Stevens <dlstevens@us.ibm.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 9:38 AM, Jun Zhao <mypopydev@gmail.com> wrote:
> ndm_type means L3 address type, in neighbour proxy and vxlan, it's RTN_UNICAST.
> NDA_DST is for netlink TLV type, hence it's not right value in this context.
>

Looks correct to me, at least libnl uses RTN_* for ndm_type.

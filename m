Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaAWSQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:16:23 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:63228 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaAWSQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <52E0C5B7.7040908@gmail.com>
References: <52E0C5B7.7040908@gmail.com>
Date: Thu, 23 Jan 2014 10:16:08 -0800
Message-ID: <CAHA+R7MGzxYGkNYrBmENcsaY_0de79xA4fHu+hPDGQK9bf21QA@mail.gmail.com>
Subject: Re: How to identify different ip tunnels
From: Cong Wang <cwang@twopensource.com>
To: zhuyj <zyjzyj2000@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 11:33 PM, zhuyj <zyjzyj2000@gmail.com> wrote:
> Here are the result that we have got:
>
> Actual Tunnel type ifi->ifi_type
> 4IN4 768
> GRE4 778
> 6IN4/6TO4/ISATAP 776
> 4IN6/6IN6/IPIN6 769
>
> So, we can NOT distinguish the actual tunnel type via ifi_type attribute
> except the GRE4 and 4IN4 tunnel. However we need the actual type. That is
> our question.

Try to search IFLA_IPTUN_PROTO. They are distinguished by protocol.

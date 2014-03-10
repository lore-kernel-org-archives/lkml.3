Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaCJTBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:01:19 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46047 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaCJTBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <1394422786-1683-1-git-send-email-linus.luessing@web.de>
References: <1394422786-1683-1-git-send-email-linus.luessing@web.de>
Date: Mon, 10 Mar 2014 12:01:16 -0700
Message-ID: <CAHA+R7O1XNRhY_psPhtP0JLxFhXbVE=bQc2J=RcFAKvYV6tMgQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] bridge: multicast: add sanity check for general query destination
From: Cong Wang <cwang@twopensource.com>
To: =?ISO-8859-1?Q?Linus_L=FCssing?= <linus.luessing@web.de>
Cc: netdev <netdev@vger.kernel.org>, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 8:39 PM, Linus Lüssing <linus.luessing@web.de> wrote:
> +       is_general_query = group && ipv6_addr_any(group) ? true : false;
> +

Just "is_general_query = group && ipv6_addr_any(group);" should be okay.

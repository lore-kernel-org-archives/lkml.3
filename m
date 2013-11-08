Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3KHA7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:59:00 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46350 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3KHA66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:58:58 -0500
Message-ID: <1383872331.9412.125.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: don't forget to free sk_filter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org.#.3.12" <stable@vger.kernel.org.#.3.12>
Date: Thu, 07 Nov 2013 16:58:51 -0800
In-Reply-To: <1383872168.9330.23.camel@jekeller-desk1.amr.corp.intel.com>
References: <1383753106-26978-1-git-send-email-avagin@openvz.org>
	 <527A9638.4020404@redhat.com>
	 <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1383872168.9330.23.camel@jekeller-desk1.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 00:56 +0000, Keller, Jacob E wrote:

> Has there been any mention of a forthcoming patch
> to ./Documentation/SubmittingPatches which documents this?

I do not remember if this point was raised, but you certainly
can submit a patch !

Thanks



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3F2HFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:05:04 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58013 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3F2HFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:05:02 -0400
Message-ID: <1372489497.3301.293.camel@edumazet-glaptop>
Subject: Re: kernel panic in skb_copy_bits
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Frank Blaschka <frank.blaschka@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "zheng.x.li@oracle.com" <zheng.x.li@oracle.com>,
        Xen Devel <xen-devel@lists.xen.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date: Sat, 29 Jun 2013 00:04:57 -0700
In-Reply-To: <51CE1E19.3020108@oracle.com>
References: <51CBAA48.3080802@oracle.com>
	  <1372311118.3301.214.camel@edumazet-glaptop> <51CD0E67.4000008@oracle.com>
	  <1372402340.3301.229.camel@edumazet-glaptop>
	 <1372412262.3301.251.camel@edumazet-glaptop> <51CE1E19.3020108@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-29 at 07:36 +0800, Joe Jin wrote:
> Hi Eric,
> 
> The patch not fix the issue and panic as same as early I posted:


At least it fixes my own panics ;)

My test bed was :

Launch 24 concurrent "netperf -t UDP_STREAM -H destination -- -m 128"

Then on "destination" disconnect the ethernet port.

While the link flaps, I got panic in a few seconds.

Thanks




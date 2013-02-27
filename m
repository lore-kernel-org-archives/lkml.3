Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716Ab3B0SOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:14:00 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37304 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760444Ab3B0SN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:13:59 -0500
Date: Wed, 27 Feb 2013 10:13:54 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
Message-ID: <20130227101354.15636ba5@nehalam.linuxnetplumber.net>
In-Reply-To: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you looked at netmap? Seems like a cleaner user API for this.

There is a version for Linux, but it needs work. My plan is to send it staging
(after merge window reopens).

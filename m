Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735Ab3B0Sro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:47:44 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64945 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035Ab3B0Srm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:47:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130227101354.15636ba5@nehalam.linuxnetplumber.net>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	<20130227101354.15636ba5@nehalam.linuxnetplumber.net>
Date: Wed, 27 Feb 2013 10:47:41 -0800
Message-ID: <CA+mtBx85G3qD2_QP709kOMERP9T8v1W+ZNj12qnZWg_kALQtLg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
From: Tom Herbert <therbert@google.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:13 AM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> Have you looked at netmap? Seems like a cleaner user API for this.
>
That might be a bit orthogonal to this.  I believe the intent it to
allow spin polling from socket calls without API change.

>
> There is a version for Linux, but it needs work. My plan is to send it staging
> (after merge window reopens).
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3HAOoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:44:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3HAOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:44:03 -0400
Date: Thu, 1 Aug 2013 17:45:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roprabhu@cisco.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] macvlan: validate flags
Message-ID: <20130801144528.GA16896@redhat.com>
References: <1375353992-7181-1-git-send-email-mst@redhat.com>
 <51FA7255.1070102@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA7255.1070102@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 06:36:05PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 01-08-2013 14:48, Michael S. Tsirkin wrote:
> 
> >commit df8ef8f3aaa6692970a436204c4429210addb23a
> 
>    Please also specify that commit's summary line in parens.
> This is the only way to uniquely identify the commit, and it's the
> requirement that came originally from Linus AFAIK.

Ouch, no idea why do I keep making this mistake.
Will do, thanks.

> >added a flags field to macvlan, which can be
> >controlled from userspace.
> >The idea is to make the interface future-proof
> >so we can add flags and not new fields.
> 
> >However, flags value isn't validated, as a result,
> >userspace can't detect which flags are supported.
> 
> >Cc: "David S. Miller" <davem@davemloft.net>
> >CC: Roopa Prabhu <roprabhu@cisco.com>
> >Cc: John Fastabend <john.r.fastabend@intel.com>
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> WBR, Sergei

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaJAQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:20:45 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64871 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJAQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:20:43 -0400
Date: Wed, 1 Oct 2014 11:20:39 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Willem de Bruijn <willemb@google.com>,
        Dave Hansen <dave.hansen@intel.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [net] 4ed2d765dfa:  ltp.recv01.4.TFAIL
Message-ID: <20141001112039.375338a0@as>
In-Reply-To: <542C2460.8020208@redhat.com>
References: <20141001152910.GA4440@wfg-t540p.sh.intel.com>
	<542C2460.8020208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014 17:57:20 +0200
Daniel Borkmann <dborkman@redhat.com> wrote:

> On 10/01/2014 05:29 PM, Fengguang Wu wrote:
> > Hi Willem,
> >
> > FYI, we noticed the below LTP failures on commit
> >
> > 4ed2d765dfaccff5ebdac68e2064b59125033a3b ("net-timestamp: TCP timestamping")
> 
> I think it already was discussed here:
> 
>    http://www.spinics.net/lists/netdev/msg297822.html


I've fixed one of those in LTP.

My proposed patch for how to fix the other three didn't get any replies
on the LTP list:

http://sourceforge.net/p/ltp/mailman/message/32866727/

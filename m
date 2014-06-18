Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaFRU3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:29:07 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53142 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaFRU3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:29:05 -0400
Date: Wed, 18 Jun 2014 13:29:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jet Chen <jet.chen@intel.com>
cc: Daniel Borkmann <dborkman@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [net] b58537a1f56: +89.2% netperf.Throughput_Mbps
In-Reply-To: <53A10291.7090301@intel.com>
Message-ID: <alpine.DEB.2.02.1406181328160.10339@chino.kir.corp.google.com>
References: <53A10291.7090301@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Jet Chen wrote:

> Hi Daniel,
> 
> FYI, we noticed the below changes on
> 
> commit b58537a1f5629bdc98a8b9dc2051ce0e952f6b4b ("net: sctp: fix permissions
> for rto_alpha and rto_beta knobs")
> 

There's no way this is legitimate, that commit cannot possibly affect the 
performance of netperf.  I wouldn't bother to spend any time investigating 
this.

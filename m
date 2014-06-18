Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaFRUlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:41:24 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39674 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbaFRUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:41:21 -0400
Date: Wed, 18 Jun 2014 13:41:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Borkmann <dborkman@redhat.com>
cc: Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [net] b58537a1f56: +89.2% netperf.Throughput_Mbps
In-Reply-To: <53A1F8D9.7070704@redhat.com>
Message-ID: <alpine.DEB.2.02.1406181340380.13111@chino.kir.corp.google.com>
References: <53A10291.7090301@intel.com> <alpine.DEB.2.02.1406181328160.10339@chino.kir.corp.google.com> <53A1F8D9.7070704@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Daniel Borkmann wrote:

> One assumption could be that netperf was setting this knob
> internally and ignoring the result of it (error/success), but
> that we might need to look up in netperf source to confirm.
> 

Confirmed netperf-2.4.5 doesn't do this.

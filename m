Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936531Ab3DJMUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936465Ab3DJMUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:20:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87k3oa65hx.fsf@rustcorp.com.au>
References: <87k3oa65hx.fsf@rustcorp.com.au> <1365543543-17522-1-git-send-email-david.a.cohen@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, David Cohen <david.a.cohen@intel.com>,
        linux-kernel@vger.kernel.org, mark.gross@intel.com
Subject: Re: [PATCH v2] MODSIGN: do not send garbage to stderr when enabling modules signature
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Apr 2013 13:20:33 +0100
Message-ID: <10221.1365596433@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> From: David Cohen <david.a.cohen@intel.com>
> Subject: MODSIGN: do not send garbage to stderr when enabling modules signature
> 
> When compiling kernel with -jN (N > 1), all warning/error messages
> printed while openssl is generating key pair may get mixed dots and
> other symbols openssl sends to stderr. This patch makes sure openssl
> logs go to default stdout.
> 
> Example of the garbage on stderr:
> 
> crypto/anubis.c:581: warning: ‘inter’ is used uninitialized in this function
> Generating a 4096 bit RSA private key
> .........
> drivers/gpu/drm/i915/i915_gem_gtt.c: In function ‘gen6_ggtt_insert_entries’:
> drivers/gpu/drm/i915/i915_gem_gtt.c:440: warning: ‘addr’ may be used uninitialized in this function
> .net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
> net/mac80211/tx.c:1780: warning: ‘chanctx_conf’ may be used uninitialized in this function
> ..drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
> .....drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: ignoring return value of ‘driver_for_each_device’, declared with attribute warn_unused_result
> 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Reviewed-by: mark gross <mark.gross@intel.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David Howells <dhowells@redhat.com>

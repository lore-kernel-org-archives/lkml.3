Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaFKUt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:49:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35268 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaFKUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:49:57 -0400
Message-ID: <1402519793.612.88.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 0/4] KEYS: validate key trust with owner and builtin
 keys only
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 11 Jun 2014 16:49:53 -0400
In-Reply-To: <5396FED1.2060802@samsung.com>
References: <1402331614.7064.60.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <cover.1402387862.git.d.kasatkin@samsung.com>
	 <1402404343.5350.1.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <5396FED1.2060802@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061120-0928-0000-0000-00000295D8FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 15:49 +0300, Dmitry Kasatkin wrote: 
> On 10/06/14 15:45, Mimi Zohar wrote:
> > On Tue, 2014-06-10 at 11:48 +0300, Dmitry Kasatkin wrote: 
> >> Hi Mimi,
> >>
> >> As you asked ofline , here is possible equivalent and simpler alternative
> >> patches not requiring to have additional keyring.
> > Please indicate which branch these patches apply to.
> >
> > thanks,
> >
> > Mimi
> >
> >
> 
> on the top of your tree #next-trusted-keys-experimental, excluding 1/4
> patch, which is yours.
> I included it by mistake because patches were on the top of that and I
> used HEAD~3 instead of HEAD~2 to send them...

This patch set removes the separate 'owner' trusted keyring.  Please
rebase your patches without the HEAD patch - "f5b4ced KEYS: define an
owner trusted keyring" and re-post.

thanks,

Mimi



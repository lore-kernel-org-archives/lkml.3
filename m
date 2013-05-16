Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3EPVEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3EPVEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:04:48 -0400
Date: Thu, 16 May 2013 17:04:43 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@redhat.com, aquini@redhat.com, mst@redhat.com,
        amit.shah@redhat.com, anton@enomsg.org
Subject: Re: [RFC v2 0/2] virtio_balloon: auto-ballooning support
Message-ID: <20130516170443.4612ec32@redhat.com>
In-Reply-To: <51954802.1040309@oracle.com>
References: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com>
	<51954802.1040309@oracle.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013 16:56:34 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 05/09/2013 10:53 AM, Luiz Capitulino wrote:
> > Hi,
> > 
> > This series is a respin of automatic ballooning support I started
> > working on last year. Patch 2/2 contains all relevant technical
> > details and performance measurements results.
> > 
> > This is in RFC state because it's a work in progress.
> 
> Hi Luiz,
> 
> Is there a virtio spec patch I could use to get it implemented on
> kvmtool?

Not yet, this will come with v1. But I got some homework to do before
posting it (more perf tests).

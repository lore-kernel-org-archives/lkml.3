Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3FYNnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3FYNnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:43:49 -0400
Message-ID: <1372167824.3739.27.camel@t520.redhat.com>
Subject: Re: linux-next: problem trying to fetch the c6x tree
From: Mark Salter <msalter@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 09:43:44 -0400
In-Reply-To: <20130625094642.801db23098e04edcf308e18b@canb.auug.org.au>
References: <20130625094642.801db23098e04edcf308e18b@canb.auug.org.au>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 09:46 +1000, Stephen Rothwell wrote:
> Hi Mark,
> 
> Attempting to fetch the c6x tree
> (git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git#for-linux-next)
> for the past two days has just produced hangs.  I am using whatever I
> have previously fetched.
> 

Hi Stephen,

I tried last night and saw the same problem. Now it is working again.
I'll try to find out what happened. Probably some infrastructure
change that I didn't get notice about.



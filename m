Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaLHNrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:47:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaLHNrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:47:12 -0500
Date: Mon, 8 Dec 2014 14:47:09 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Alexander Graf <agraf@suse.de>
cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
In-Reply-To: <5480F057.9010203@suse.de>
Message-ID: <alpine.LNX.2.00.1412081440340.405@wotan.suse.de>
References: <1417707993-82290-1-git-send-email-agraf@suse.de> <20141204182049.GB7749@arm.com> <5480F057.9010203@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 5 Dec 2014, Alexander Graf wrote:

> I don't have a full distribution for you yet, but we'll start to switch 
> to the 2.25 branch soon.
> 
> Michael, what are you plans on when a first armv7 Factory build based on 
> 2.25 would be available?

2.25 isn't released yet, but I just submitted the pre-release version to 
Factory, so the answer would be "as soon as it's checked in" :)


Ciao,
Michael.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaF3HlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:41:03 -0400
Received: from 8bytes.org ([85.214.48.195]:33598 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaF3HlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:41:01 -0400
Date: Mon, 30 Jun 2014 09:40:58 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: Re: [git pull] IOMMU Fixes for Linux v3.16-rc2
Message-ID: <20140630074058.GA26537@8bytes.org>
References: <20140624085418.GB2782@8bytes.org>
 <CAADWXX_TzcJQ3K07MsK1Ua6QqmTwDiqUM7aZYnZXWj9t9A_OmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADWXX_TzcJQ3K07MsK1Ua6QqmTwDiqUM7aZYnZXWj9t9A_OmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 30 09:40:59 2014
X-DSPAM-Confidence: 0.9979
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b1148b20861810150096
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jun 27, 2014 at 07:03:45PM -0700, Linus Torvalds wrote:
>  this email was in my spam-box. No real indication as to why, although
> the usual suspect is
> 
>    Received-SPF: none (google.com: joro@8bytes.org does not designate
> permitted sender hosts) client-ip=85.214.48.195;

Hmm, I tried to enable SPF for 8bytes.org on the weekend. Unfortunatly
my server provider only allows me to edit DNS via some GUI which has no
SPF switch... Anyway, I'll try to find a solution for that.

> presumably together with some other trigger that makes gmail unhappy.
> 
> Anyway, pulled,

Thanks!


	Joerg



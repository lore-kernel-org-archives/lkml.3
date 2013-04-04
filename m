Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3DDA3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:29:55 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:43225 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013Ab3DDA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:29:54 -0400
Message-ID: <515CC97F.5020200@pobox.com>
Date: Wed, 03 Apr 2013 20:29:51 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-crypto@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, herbert@gondor.hengli.com.au,
        davem@davemloft.net
Subject: Re: [PATCH v0] Add SHA-3 hash algorithm
References: <20121003054542.GA2416@havoc.gtf.org>
In-Reply-To: <20121003054542.GA2416@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 01:45 AM, Jeff Garzik wrote:
>
> Whee -- SHA-3 is out!   I wanted to explore the new toy a bit, and
> so, here is a blatantly untested rough draft of SHA-3 kernel support.
>
> Why rough draft?  Because answers to the questions below will inform a
> more polished version.

Just to update people...  this has been in a holding pattern, because 
apparently there are revisions to SHA-3 coming down the pipe.  They want 
to address preimage resistance, and make things faster in hardware.

Random quote from NIST, on the NIST hash-forum, which doesn't provide 
detail but does summarize general feeling: "As best we can tell, 
continuing to pay that performance penalty for all future uses of SHA3 
has no benefit.  (All this is a longwinded way of saying: we were wrong, 
but hopefully we got better.)"

	Jeff





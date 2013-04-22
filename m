Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3DVNFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:05:19 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:33770 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3DVNFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:05:17 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2013 09:05:17 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
Date: Mon, 22 Apr 2013 14:58:21 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org
References: <u48v4ast6w.fsf@md.dent.med.uni-muenchen.de>
In-Reply-To: <u48v4ast6w.fsf@md.dent.med.uni-muenchen.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201304221458.21916.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Wolfram Gloger wrote:
> Hi,
>
> >Yeah, I was thinking of asking my old contacts about it but it is simply
> >not worth it. Those CPUs are on their way to the museum if they're not
> >there already.
>
> I have a perfectly running K6 system (the legendary K6-III I believe),
> though I am about to have it taken to recycling.
> If you want anything tested, I can still do it this week.

This bug was present on the original K6 only, not K6-2 or K6-3. I think that I 
have a K6 somewhere but I doubt that it's one of the early buggy ones.

Here are the details: http://membres.multimania.fr/poulot/k6bug_faq.html

-- 
Ondrej Zary

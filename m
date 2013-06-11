Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3FKTSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3FKTSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:18:01 -0400
Date: Tue, 11 Jun 2013 15:17:46 -0400
From: Dave Jones <davej@redhat.com>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, herbert@gondor.hengli.com.au,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: GPF in aesni_xts_crypt8 (3.10-rc5)
Message-ID: <20130611191746.GA31945@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	herbert@gondor.hengli.com.au,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20130611172624.GA20496@redhat.com>
 <51B773ED.9080308@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B773ED.9080308@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 10:01:01PM +0300, Jussi Kivilinna wrote:
 > Hello,
 > 
 > Does attached patch help?
 > 
 > crypto: aesni_intel - fix accessing of unaligned memory

It does, thanks for the quick turnaround! 

	Dave


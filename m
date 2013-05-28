Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab3E1Vwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:52:53 -0400
Received: from mout.gmx.net ([212.227.17.21]:53534 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab3E1Vwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:52:51 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/7RP9+OZb7zLCpXjOxObSkKEgwJpvfjHldT5A8G1
	nXr9SZ301/hf9w
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v2] drivers/tpm: add xen tpmfront interface
Date: Tue, 28 May 2013 23:58:27 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Ian.Campbell@citrix.com,
        JBeulich@suse.com, xen-devel@lists.xen.org
References: <1365692161-13735-1-git-send-email-dgdegra@tycho.nsa.gov> <20130522191551.GB10617@phenom.dumpdata.com> <51A4CFFB.2060106@tycho.nsa.gov>
In-Reply-To: <51A4CFFB.2060106@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305282358.27615.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Daniel De Graaf wrote:
> I wasn't sure if this patch goes in via a Xen tree or TPM driver
> maintainers. I'll CC the full list from scripts/get_maintainer.pl
> on my v3 submission.

I'd suggest to get at least an ack from both subsystems, as most people aren't 
expert in both fields -- then it doesn't really matter who pulls it.

I still have to clarify (with my company) whether I can take over the 
maintainership for the tpm subsystem as suggested by Kent,
but I'll (try to) give it a review anyways.


Thanks,
Peter


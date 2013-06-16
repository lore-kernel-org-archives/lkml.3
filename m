Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3FPLeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:34:08 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43084 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3FPLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:34:05 -0400
Date: Sun, 16 Jun 2013 13:33:56 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 26/31] mips/kvm: Split up Kconfig and Makefile
 definitions in preperation for MIPSVZ.
Message-ID: <20130616113356.GH20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-27-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-27-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Trademark guys (and readability in general) sould probably be happier
if MIPSTE was spelled as MIPS_TE and for that matter, MIPZVZ as MIPS_VZ?

Other than that,

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf

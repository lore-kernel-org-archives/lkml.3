Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3FNNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:21:26 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37826 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3FNNVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:21:24 -0400
Date: Fri, 14 Jun 2013 15:21:20 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 08/31] mips/kvm: Fix code formatting in
 arch/mips/kvm/kvm_locore.S
Message-ID: <20130614132120.GJ15775@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-9-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-9-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, here's you're taking care of my eariler complaint about the formatting
of kvm_locore.S.  I'd have done things in a different order to avoid the
inconsistent formatting - even if that was only a temporary state.  But
anyway,

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf

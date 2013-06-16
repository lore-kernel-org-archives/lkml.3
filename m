Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3FPL2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:28:51 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43084 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3FPL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:28:49 -0400
Date: Sun, 16 Jun 2013 13:28:44 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 23/31] mips/kvm: Hook into CP unusable exception handler.
Message-ID: <20130616112844.GE20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-24-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-24-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:27PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The MIPS VZ KVM code needs this to be able to manage the FPU.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Looks good, Acked-by: Ralf Baechle <ralf@linux-mips.org>.

However I get cold shivers at the thought of SMTC FPU management with VZ,
it sounds like a source of new entertainment ...  But thinkin gaobu this
is something for another rainy day, not now.

  Ralf

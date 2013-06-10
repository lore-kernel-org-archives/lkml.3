Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3FJQnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:43:09 -0400
Received: from kymasys.com ([64.62.140.43]:44157 "HELO kymasys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751562Ab3FJQnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:43:08 -0400
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via the MIPS-VZ extensions.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Sanjay Lal <sanjayl@kymasys.com>
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 10 Jun 2013 09:43:12 -0700
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8D7771A4-B51E-4FA8-9342-621FE41792DE@kymasys.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2013, at 4:03 PM, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> These patches take a somewhat different approach to MIPS
> virtualization via the MIPS-VZ extensions than the patches previously
> sent by Sanjay Lal.
> 
> Several facts about the code:
> 
> 
> o Currently probably only usable on the OCTEON III CPU model, as some
>  MIPS-VZ implementation-defined behaviors were assumed to have the
>  OCTEON III behavior.
> 


I've only briefly gone over the patches, but I was wondering if the Cavium implementation has support for GuestIDs, which are optional in the VZ-ASE?

Regards
Sanjay



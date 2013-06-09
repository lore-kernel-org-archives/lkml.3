Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3FIXkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:40:45 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47051 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3FIXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:40:44 -0400
Date: Mon, 10 Jun 2013 00:40:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Daney <david.s.daney@gmail.com>
cc: Gleb Natapov <gleb@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
In-Reply-To: <51B50E87.2060501@gmail.com>
Message-ID: <alpine.LFD.2.03.1306100030210.18329@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <51B26974.5000306@caviumnetworks.com> <20130609073115.GE4725@redhat.com> <51B50E87.2060501@gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Jun 2013, David Daney wrote:

> >   How different MIPS SMP systems are?
> 
> o Old SGI heavy metal (several different system architectures).
> 
> o Cavium OCTEON SMP SoCs.
> 
> o Broadcom (several flavors) SoCs
> 
> o Loongson

o Old DEC hardware (DECsystem 58x0, R3000-based).

o Malta-based MIPS Technologies CMP solutions (1004K, 1074K, interAptiv).

  Maciej

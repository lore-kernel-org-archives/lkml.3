Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3FPL74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:59:56 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43240 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3FPL7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:59:38 -0400
Date: Sun, 16 Jun 2013 13:59:26 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <david.s.daney@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>, kvm@vger.kernel.org,
        linux-mips@linux-mips.org, Sanjay Lal <sanjayl@kymasys.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 00/31] KVM/MIPS: Implement hardware virtualization via
 the MIPS-VZ extensions.
Message-ID: <20130616115926.GM20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <51B26974.5000306@caviumnetworks.com>
 <20130609073115.GE4725@redhat.com>
 <51B50E87.2060501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B50E87.2060501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 04:23:51PM -0700, David Daney wrote:

> Come to think of it, Emulating SGI hardware might be an interesting
> case.  There may be old IRIX systems and applications that could be
> running low on real hardware.  Some of those systems take up a whole
> room and draw a lot of power.  They might run faster and at much
> lower power consumption on a modern 48-Way SMP SoC based system.

Many SGI MIPS system have RTCs powered by builtin batteries with a
nominal livetime of ten years and for which no more replacements are
available.  This is beginning to limit usable SGI MIPS systems to those
who know how to solve these issues with a Dremel and a soldering iron.

That said, SGI platforms are all more or less weird custom architectures
so the platform emulation - let alone the firmware blobs - will be a
chunk of work.

  Ralf

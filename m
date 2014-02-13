Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaBMNDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:03:54 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48066 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910AbaBMNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:03:52 -0500
X-Sasl-enc: kgygwOwnlsNbWp2F+jawzVIvrmByN5QKgBTyVWSPZTJB 1392296629
Date: Thu, 13 Feb 2014 11:03:44 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: dl9pf@gmx.de
Cc: Behan Webster <behanw@converseincode.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from
 Thinkpad ACPI
Message-ID: <20140213130343.GA25725@khazad-dum.debian.net>
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, dl9pf@gmx.de wrote:
> From: Behan Webster <behanw@converseincode.com>
> The only real change is passing in event_mask to the formerly nested functions.
> Otherwise it's just moving around function and macro code.
> 
> This is the only place in the Linux kernel where nested functions are still in
> use. Nested functions aren't part of the C standards, and complicate the
> generated code. Although the Linux Kernel has never set out to be entirely C
> standard compliant, it is increasingly compliant to the standard which is
> supported by other compilers such as Clang. The LLVMLinux project is working on
> being able to compile the Linux kernel with Clang. The use of nested functions
> blocks this effort.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> 
> CC: David Woodhouse <David.Woodhouse@intel.com>
> CC: Matthew Garrett <matthew.garrett@nebula.com>
> CC: ibm-acpi-devel@lists.sourceforge.net
> CC: platform-driver-x86@vger.kernel.org
> CC: linux-kernel@vger.kernel.org

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

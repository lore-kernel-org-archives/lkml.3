Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaHEAf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:35:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:34208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbaHEAf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:35:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,801,1400050800"; 
   d="scan'208";a="553714198"
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Hoffman <daniel_j_hoffman@inbox.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What binutils version is needed for kernel LTO
References: <E0D42739B2B.0000096Cdaniel_j_hoffman@inbox.com>
Date: Mon, 04 Aug 2014 17:35:56 -0700
In-Reply-To: <E0D42739B2B.0000096Cdaniel_j_hoffman@inbox.com> (Daniel
	Hoffman's message of "Mon, 4 Aug 2014 15:09:45 -0800")
Message-ID: <878un3wz6b.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hoffman <daniel_j_hoffman@inbox.com> writes:

> I hate to ask it here but I cannot for the life of me compile linux
> with these. It always kicks it back and says "scripts/Makefile.lto:76:
> "WARNING: Too old linker version for kernel LTO. You need Linux
> binutils. CONFIG_LTO disabled."". I am running the latest version from
> Ubuntu and it matches up with the latest version from gnu.org. What do
> I have to do?

See Documentation/lto-build.

You need the Linux binutils from
https://www.kernel.org/pub/linux/devel/binutils/

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

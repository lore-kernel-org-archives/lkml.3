Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3FYII6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:08:58 -0400
Received: from p-mail2.rd.orange.com ([195.101.245.16]:58556 "EHLO
	p-mail2.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3FYIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:08:47 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 04:08:46 EDT
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 15/15] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Tue, 25 Jun 2013 10:01:12 +0200
User-Agent: KMail/1.13.5 (Linux/3.9.3-ilmarinen-nv; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <cover.1372097219.git.yann.morin.1998@free.fr> <8357b48549e17b3e4e402c7f977b65708922e60f.1372097219.git.yann.morin.1998@free.fr>
In-Reply-To: <8357b48549e17b3e4e402c7f977b65708922e60f.1372097219.git.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306251001.12430.yann.morin.1998@free.fr>
X-OriginalArrivalTime: 25 Jun 2013 08:01:12.0885 (UTC) FILETIME=[290ADE50:01CE717A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On Monday 24 June 2013 20:11:59 Yann E. MORIN wrote:
> Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> is specified.
[--SNIP--]
> This patch defers setting that a choice has a value until a symbol for
> that choice is indeed set, so that choices are properly randomised when
> KCONFIG_ALLCONFIG is set, but not if a symbol for that choice is set.

I've just been informed by Fengguang that this patch breaks yet another
use-case of his, but this time KCONFIG_ALLCONFIG is not involved.

I'll investigate this issue when I'm back home tonight (ie. ~16:00 UTC).
Sorry for the breakage (again...). :-(

We really need a known, shared test-suite for kconfig... :-/

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'

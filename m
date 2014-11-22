Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaKVQbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:31:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46381 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaKVQbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:31:45 -0500
Date: Sat, 22 Nov 2014 17:31:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: rui wang <ruiv.wang@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141122163141.GA4395@pd.tnic>
References: <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
 <20141121181334.GC4274@pd.tnic>
 <CANVTcTa_AVM01VeVBYiSiB3Q0sJagy2hh-xYAjJv70jCWoDHYA@mail.gmail.com>
 <20141122094433.GA12152@pd.tnic>
 <CANVTcTaz6pZ=oc0omXa-nPD8G3uOfCVKag-VC66x5gNeGkrgvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANVTcTaz6pZ=oc0omXa-nPD8G3uOfCVKag-VC66x5gNeGkrgvQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 11:32:00PM +0800, rui wang wrote:
> But that means mcelog buffer will have to become circular, and we can
> only dump the last 32 errors. There must be a reason why it wasn't
> designed as circular.

Is there? Please do tell because I don't know the reason why.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

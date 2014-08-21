Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaHUMbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:31:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60914 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbaHUMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:31:46 -0400
X-Sasl-enc: 86ZWeV2GzWfnkwBzl5QgE2yQ9UfdnQ29RJY7c9puuUhq 1408624305
Date: Thu, 21 Aug 2014 09:31:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-firmware@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Automatically pull missing FW files
Message-ID: <20140821123133.GB14973@khazad-dum.debian.net>
References: <20140820182145.15596.86122.stgit@tstruk-mobl1>
 <1408559681.11365.1.camel@shinybook.infradead.org>
 <53F4F533.5010308@intel.com>
 <1408567140.9484.0.camel@infradead.org>
 <53F509AF.9010707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F509AF.9010707@intel.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Tadeusz Struk wrote:
> What for? The point is that you don't have the FW binary file and you
> have to download it, which can happen automatically and this is what
> this patch does. The director where it will be stored doesn't really
> matter here.

"git pull" will at least tell you something is seriously wrong (if you know
the firmware tree should never require a forced update, that is).

I'd really appreciate if the firmware tree had signed tags or signed
commits, though.  Those at least provide decent end-to-end security (both at
rest, and while in transit) for data once it has been "git push"'d.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

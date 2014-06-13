Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaFMSWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:22:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaFMSWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:22:24 -0400
Date: Fri, 13 Jun 2014 20:22:20 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC v2] printk: allow increasing the ring buffer depending on
	the number of CPUs
Message-ID: <20140613182220.GB4841@wotan.suse.de>
References: <1402611369-4811-1-git-send-email-mcgrof@do-not-panic.com> <20140613091441.GO7772@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140613091441.GO7772@pathway.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:14:41AM +0200, Petr Mládek wrote:
> Beside the cosmetic changes, I really like the patch. It solves the
> problem an elegant way.

Thanks, I've amended all the recommended cosmetic changes. Will submit
as patch now.

  Luis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaGVF12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:27:28 -0400
Received: from purkki.adurom.net ([80.68.90.206]:36056 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaGVF11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:27:27 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, apw@canonical.com, tytso@mit.edu,
        dwalter@google.com, bp@suse.de, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
References: <1405611268-12463-1-git-send-email-richard@nod.at>
	<1405612283.12363.10.camel@joe-AO725> <20140717160236.GD22791@pd.tnic>
Date: Tue, 22 Jul 2014 08:27:22 +0300
In-Reply-To: <20140717160236.GD22791@pd.tnic> (Borislav Petkov's message of
	"Thu, 17 Jul 2014 18:02:36 +0200")
Message-ID: <87vbqq9d51.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> No, checkpatch should only check patches and not whole file. It is
> wrong. Fullstop.

Please don't remove --file, I use it all the time when maintaining
ath6kl and ath10k. It's a lot easier in my workflow to test the whole
driver in one go than start testing individual patches.

-- 
Kalle Valo

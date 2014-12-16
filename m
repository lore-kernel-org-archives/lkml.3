Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaLPHID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:08:03 -0500
Received: from purkki.adurom.net ([80.68.90.206]:46933 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaLPHIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:08:01 -0500
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 02:08:00 EST
From: Kalle Valo <kvalo@adurom.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 2/4] Documentation/SubmitChecklist: Remind submitters to check the merge window
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
	<1418623790-28429-3-git-send-email-cernekee@gmail.com>
Date: Tue, 16 Dec 2014 08:48:33 +0200
In-Reply-To: <1418623790-28429-3-git-send-email-cernekee@gmail.com> (Kevin
	Cernekee's message of "Sun, 14 Dec 2014 22:09:48 -0800")
Message-ID: <87iohc2ipq.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Cernekee <cernekee@gmail.com> writes:

> +27: For patches which are not urgent fixes for bugs in the current tree,
> +    double-check https://www.kernel.org/ to make sure the merge window is
> +    CLOSED ("mainline:" showing an -rc kernel) before sending.  For more
> +    information on the release cycle, see Documentation/development-process/.

Maybe the crystal ball should be extended to show if the merge is open
or closed? And if it's closed, an estimate when the next merge window
starts would be nice ("Merge window is closed, estimate for it to open:
21 days").

http://phb-crystal-ball.org/

I'm sure Johannes would be happy to take patches.

-- 
Kalle Valo

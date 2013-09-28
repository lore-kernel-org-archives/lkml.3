Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3I1Rle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:41:34 -0400
Received: from d-paulus.de ([37.221.197.252]:34309 "EHLO d-paulus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab3I1Rlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:41:32 -0400
Date: Sat, 28 Sep 2013 19:41:30 +0200
From: Dominik Paulus <dominik@d-paulus.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dominik Paulus <dominik.paulus@fau.de>, linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de
Subject: Re: [PATCHv2 0/11] staging: usbip: Userland crypto and ACLs
Message-ID: <20130928174130.GA3325@d-paulus.de>
References: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
 <20130925233638.GA21396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925233638.GA21396@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 04:36:38PM -0700, Greg Kroah-Hartman wrote:
> Only the first patch could be applied. Can you refresh this series, and
> your other one (fixing the issues pointed out there), and resend them
> please?

We've incorporated all of Dan's fixes and suggestions and rebased the
whole series on staging-next.
We left the protocol version at 0x111, since the code is backwards
compatible with current linux-linus if encryption is disabled.
After reading "NIST Special Publication 800-38D" Appendix C we got some
doubts about the security of our usage of gcm with short (4 bytes) tags,
so we incremented USBIP_AUTHSIZE to 16, just to be safe.

Thanks,
Tobias and Dominik

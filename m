Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaGXPSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:18:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58033 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251AbaGXPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:18:26 -0400
X-Sasl-enc: ZQn+0b4U0vjTP4p26GU7xal1jS5C1G1gOuwdFTGyl4n0 1406215105
Date: Thu, 24 Jul 2014 12:18:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -v5] random: introduce getrandom(2) system call
Message-ID: <20140724151814.GE32421@khazad-dum.debian.net>
References: <1406212287-9855-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406212287-9855-1-git-send-email-tytso@mit.edu>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Theodore Ts'o wrote:
> ERRORS
> 	EINVAL		An invalid flag was passed to getrandom(2)
> 
> 	EFAULT		buf is outside the accessible address space.
> 
> 	EAGAIN		The requested entropy was not available, and
> 			getentropy(2) would have blocked if GRND_BLOCK flag
> 			was set.
> 
> 	EINTR		While blocked waiting for entropy, the call was
> 			interrupted by a signal handler; see the description
> 			of how interrupted read(2) calls on "slow" devices
> 			are handled with and without the SA_RESTART flag
> 			in the signal(7) man page.

Should we add E<SOMETHING> to be able to deny access to GRND_RANDOM or some
future extension ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

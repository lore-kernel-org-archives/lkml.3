Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJML2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:28:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34666 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbaJML2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:28:50 -0400
X-Sasl-enc: c4B2Y7wr0s5apAbNpIRYHs7lsY8Y6oultnCDVmI2FLd8 1413199727
Date: Mon, 13 Oct 2014 08:28:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141013112834.GA10826@khazad-dum.debian.net>
References: <20141013022454.289398272@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.17.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Actually, 3.17 is a filesystem killer for some unlucky users due to the
libata blacklist being disabled by a bug.

Patch:
https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/patch/?id=1c40279960bcd7d52dbdf1d466b20d24b99176c8
1c40279960bcd7d52dbdf1d466b20d24b99176c8 (libata: Un-break ATA blacklist)

I am not complaining that the patch hasn't made it to 3.17.1 (or even
mainline) yet.  This is just a head's up to those that might be affected by
the problem.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

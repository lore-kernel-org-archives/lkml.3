Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaIRAsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:48:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40638 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbaIRAsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:48:53 -0400
X-Sasl-enc: X1opG3U5igcZwMxZClErMqSEXm6CILuswe8hO3jytskb 1411001332
Date: Wed, 17 Sep 2014 21:48:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20140918004841.GB18652@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Henrique de Moraes Holschuh wrote:
> Change the early microcode driver to make a temporary copy of a portion
> of the microcode header, and move the microcode data backwards
> (overwriting the header) to a suitably aligned position, right before
> issuing the microcode update WRMSR.

This one is missing a big thank you to Bill Davidsen for the "overwrite the
header" idea.  Once I get some comments about this series, I will respin
this one and credit him.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

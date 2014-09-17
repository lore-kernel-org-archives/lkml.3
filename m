Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaIQKqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:46:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58113 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbaIQKqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:46:03 -0400
X-Sasl-enc: PAsuavP3xs+SB6Kg5AyiG+fypMPvzpeZZZMtCCpYarBM 1410950762
Date: Wed, 17 Sep 2014 07:45:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Darren Hart <dvhart@infradead.org>
Cc: Jan van den Berg <janvdberg@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: thinkpad_acpi.c: fixed spacing coding style issue
Message-ID: <20140917104550.GB8594@khazad-dum.debian.net>
References: <1410904868-10406-1-git-send-email-janvdberg@gmail.com>
 <20140916221236.GB12780@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916221236.GB12780@vmdeb7>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Darren Hart wrote:
> On Wed, Sep 17, 2014 at 12:01:08AM +0200, Jan van den Berg wrote:
> > Fixed 22 similar coding style issues: "ERROR: spaces required around that '?'"
> > 
> > Signed-off-by: Jan van den Berg <janvdberg@gmail.com>
> 
> Queued, thanks.

I usually refuse "fix whitespace" patches because git blame is not smart
enough to skip such commits.    They effectively pollute history for zero
gain.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

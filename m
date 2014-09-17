Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaIQMsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:48:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35112 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbaIQMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:48:48 -0400
X-Sasl-enc: 3D7G/R4c6SIzNgm+QI69gZBJFiB+dgoRVkAh/CsC9S/I 1410958127
Date: Wed, 17 Sep 2014 09:48:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jan van den Berg <janvdberg@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: thinkpad_acpi.c: fixed spacing coding style issue
Message-ID: <20140917124835.GA30371@khazad-dum.debian.net>
References: <1410904868-10406-1-git-send-email-janvdberg@gmail.com>
 <20140916221236.GB12780@vmdeb7>
 <20140917104550.GB8594@khazad-dum.debian.net>
 <CAA-PxD-e-SGQO3eO0PLn9GVdSwXOT=y+Ycsxkm7KtfKhbCcNdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA-PxD-e-SGQO3eO0PLn9GVdSwXOT=y+Ycsxkm7KtfKhbCcNdw@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Jan van den Berg wrote:
> I will try and make _real_ contribution next time. (With this being my
> first ever submission to the kernel: at least now I understand the kernel
> workflow.)

There's nothing wrong with your patch by itself.  And git does try to help
us take such patches (there's "git blame -w")... but ignoring whitespace
changes doesn't always work as well as one would like.

That said, Darren has already queued your patch, and I am _not_ going to ask
him to drop it.  So, as far as I'm concerned, the patch has been accepted,
and that's it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

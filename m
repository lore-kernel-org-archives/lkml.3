Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab3GWTHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:07:15 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:53604 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3GWTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:07:11 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhRoAIrT7lFV5qu1PGdsb2JhbABbgwaDJSIBhQC5EwQBgRIXAwEBAQE4NYIkAQEEATocEwEPBQsIAyElDwUlChoTiAoKuFMWjkqBHQeDEm4Dl16GM44xOg
X-IronPort-AV: E=Sophos;i="4.89,729,1367964000"; 
   d="scan'208";a="588911477"
From: rydberg@euromail.se
Date: Tue, 23 Jul 2013 21:08:55 +0200
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andre Heider <a.heider@gmail.com>
Subject: Re: Linux 3.11-rc2
Message-ID: <20130723190855.GA509@polaris.bitmath.org>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
 <20130723010437.GA570@polaris.bitmath.org>
 <1374542261.7972.66.camel@leira.trondhjem.org>
 <1374604305.12943.3.camel@leira.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374604305.12943.3.camel@leira.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

> OK. With Andre's help, I think we've root caused the problem. Can you
> please confirm that the attached patch also solves the issue for you?

Seems to work fine,

   Reported-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

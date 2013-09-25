Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3IYNta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:49:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60540 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328Ab3IYNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:49:29 -0400
X-Sasl-enc: ZCVxYNt36oHHaY/YBeeD9zM8KCuNsORV5LtbYpTs4Roa 1380116968
Date: Wed, 25 Sep 2013 10:49:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with AMD microcode updates
Message-ID: <20130925134922.GA14087@khazad-dum.debian.net>
References: <20130919145834.GA4298@khazad-dum.debian.net>
 <20130919164409.GA9427@pd.tnic>
 <524221A5.9070808@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524221A5.9070808@amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Sherry Hurwitz wrote:
> You can direct AMD microcode issues to me now.
> We are setting up some systems in the lab and trying to duplicate
> the problem now.

Thank you!

If you're going to be taking care of AMD microcode update issues, maybe it
would be a good idea to add your name to the MAINTAINERS file for the "AMD
MICROCODE UPDATE SUPPORT", and remove the (dead for a while now)
amd64-microcode@amd64.org mailing list?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

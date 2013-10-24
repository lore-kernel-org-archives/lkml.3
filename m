Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3JXJic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:38:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36685 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab3JXJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:38:29 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 05:38:29 EDT
X-Sasl-enc: NS33enTr1PRFudrVqz8IKQyyUy1bING4R7k6La5BMKDx 1382607070
Date: Thu, 24 Oct 2013 07:31:07 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Ike Panhc <ike.pan@canonical.com>, Harald Welte <laforge@gnumonks.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/8] platform:x86: Remove OOM message after
 input_allocate_device
Message-ID: <20131024093107.GA24862@khazad-dum.debian.net>
References: <cover.1382555436.git.joe@perches.com>
 <93f2f693853e4409877d3d639e39b3b497738757.1382555436.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93f2f693853e4409877d3d639e39b3b497738757.1382555436.git.joe@perches.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Joe Perches wrote:
> Emitting an OOM message isn't necessary after input_allocate_device
> as there's a generic OOM and a dump_stack already done.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For the thinkpad-acpi bits:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

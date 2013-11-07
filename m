Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3KGM1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:27:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49688 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab3KGM1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:27:04 -0500
X-Sasl-enc: qnr7I/kKAmh3kZFpd7Czr1CfKg1XL7dTXoFiLQaoZ/sN 1383827221
Date: Thu, 7 Nov 2013 10:26:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: akpm@linux-foundation.org, karl.kiniger@med.ge.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org, t.artem@lycos.com, linux-mm@kvack.org,
        mgorman@suse.de, jack@suse.cz, fengguang.wu@intel.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: add strictlimit knob -v2
Message-ID: <20131107122658.GA3355@khazad-dum.debian.net>
References: <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
 <20131106150515.25906.55017.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106150515.25906.55017.stgit@dhcp-10-30-17-2.sw.ru>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason to not enforce strictlimit by default?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

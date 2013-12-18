Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3LRLsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:48:05 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43032 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab3LRLsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:48:03 -0500
X-Sasl-enc: YCNuyduqoph2L76+1YxWq57QTYi/YSf7KD0Nrt4X0pBT 1387367282
Date: Wed, 18 Dec 2013 09:48:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] n_tty: Fix buffer overruns with larger-than-4k pastes
Message-ID: <20131218114800.GC29631@khazad-dum.debian.net>
References: <52A79030.9090403@hurleysoftware.com>
 <1386713522-6959-1-git-send-email-peter@hurleysoftware.com>
 <20131217005719.GA26381@kroah.com>
 <52AFA7CF.3050800@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AFA7CF.3050800@hurleysoftware.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Peter Hurley wrote:
> >Is this a 3.13-final thing, or can it wait for 3.14-rc1?
> 
> Definitely not 3.13 at this point -- it should go to -next.

Please earmark it for stable, if possible. This fixes a rather annoying long
time bug, after all...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

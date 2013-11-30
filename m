Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3K3NEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:04:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54213 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab3K3NEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:04:25 -0500
X-Sasl-enc: 4YEU/+Ivb+gwcqpaArYDvH6Skm75kKLq8s8Hikhqa7ZE 1385816664
Date: Sat, 30 Nov 2013 11:04:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: venkata koppula <vmrkoppula@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Copying large files eats all of the RAM
Message-ID: <20131130130417.GA21857@khazad-dum.debian.net>
References: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
 <52992659.5040503@gmail.com>
 <CAKK=TULveq5m2zX9YQS_v3KUp04qV+XME06tEhFx9upHG7D00w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKK=TULveq5m2zX9YQS_v3KUp04qV+XME06tEhFx9upHG7D00w@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, venkata koppula wrote:
> Yeah, I understand that we need to utilize the resources as much as we
> can. At the same time user should not
> feel that system is slow and user should never wait for the copying
> operation should complete to launch another
> application meanwhile.

http://thread.gmane.org/gmane.linux.kernel.mm/108708/focus=1588604

Can also help when you have a mix of slow-as-heck and fast devices.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbaAaS0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:26:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37739 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932836AbaAaS0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:26:05 -0500
X-Sasl-enc: xQXxeu5KPs0RJ6Kschp01CrWBzPUDrGtkHtfmf+TiV7x 1391192757
Date: Fri, 31 Jan 2014 16:25:51 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: Re: That greedy Linux VM cache
Message-ID: <20140131182551.GA23916@khazad-dum.debian.net>
References: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Igor Podlesny wrote:
>    Probably every Linux newcomer's going to have concerns regarding
> low free memory and hear an explanation from Linux old fellows that's
> actually there's plenty of -- it's just cached, but when it's needed
> for applications it's gonna be used -- on demand. I also thought so

Yeah right, we wish it would...

Anyway, maybe this helps?
http://thread.gmane.org/gmane.linux.kernel.mm/112554/focus=81834

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

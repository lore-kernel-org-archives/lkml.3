Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3JCKXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:23:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51280 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898Ab3JCKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:23:04 -0400
X-Sasl-enc: 2Tzga0QaZj3etynqKsNbKCnUtBExIGnhNfdUahsQ+/bg 1380795778
Date: Thu, 3 Oct 2013 07:22:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NUMA processor numbering
Message-ID: <20131003102255.GA2086@khazad-dum.debian.net>
References: <20131003120514.36128d85.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003120514.36128d85.skraw@ithnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct 2013, Stephan von Krawczynski wrote:
> Does the above output mean that the cores are numbered right across the two
> physical cpus? Does this mean one has to pin processes to 0,2,4,... to stay in
> "short distance" to node 0 RAM?

...

> If so, it would be a lot better to have them numbered 0-15 and 16-31 for pinning.
> Is there a way to achieve this?

Yes, use hwloc to get the pinning masks for whatever property you want (e.g.
all threads in a given core, all threads in a given node, all threads that
share a given L3 cache...).

http://www.open-mpi.org/projects/hwloc/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

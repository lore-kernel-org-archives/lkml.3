Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3HWS2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:28:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36452 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565Ab3HWS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:28:38 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 14:28:38 EDT
X-Sasl-enc: PpoRv2Wygggax25OJYs17DZrF6XEfNZevpNyZu3zZ+Gi 1377281908
Date: Fri, 23 Aug 2013 15:18:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com, rjw@sisk.pl,
        len.brown@intel.com, dtor@insightbb.com
Subject: Re: [PATCH 3/3] thinkpad_acpi: Wire unused micmute LED to capslock
Message-ID: <20130823181826.GB27893@khazad-dum.debian.net>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
 <1377180132-4933-3-git-send-email-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377180132-4933-3-git-send-email-Jason@zx2c4.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Jason A. Donenfeld wrote:
> Thinkpads with a micmute LED do not have a capslock LED. The micmute LED
> is currently not used by any piece of Linux kernel land or user land. It
> seems reasonable to hook it up to caps lock, at least by default, so
> users can have some degree of functionality.

NACK.  This we won't do.  It is a LED misuse, and it will get in the way
when we finally put that LED to its proper use.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3IWLy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:54:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49347 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272Ab3IWLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:54:57 -0400
X-Sasl-enc: mYMHo7VCsMkDhfpqDtVK/wWqUunc/uXFxCY+q8VmyE+t 1379937294
Date: Mon, 23 Sep 2013 08:54:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Cc: "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] [RFC] LED on micmute
Message-ID: <20130923115451.GA29847@khazad-dum.debian.net>
References: <1379873131.2949.3.camel@ThinkPad-X230.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379873131.2949.3.camel@ThinkPad-X230.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep 2013, Igor Gnatenko wrote:
> Hi all! How about fix this problem ?
> I have ThinkPad X230 and have micmute button, which works correctly and
> LED on this button, which doesn't work.
> I looked older threads[0] about this, but nothing changed since 2011..

The problem is not on the thinkpad-acpi side.  It is on the "integrate it
with the MIC gate".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

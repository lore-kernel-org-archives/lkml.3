Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3FRAU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:20:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48095 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3FRAU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:20:26 -0400
X-Sasl-enc: h2MdU8n2EMq5t7RWjhxiXqbqnB6a82a8o+AmH6IwOFyK 1371514825
Date: Mon, 17 Jun 2013 21:20:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't
 have EC controllable LEDs
Message-ID: <20130618002022.GE27654@khazad-dum.debian.net>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jun 2013, Adam Lee wrote:
> Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs.
> This patch adds their quirks.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

NAK.

Let's see if we can do this in a better way that is a bit more future-proof.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

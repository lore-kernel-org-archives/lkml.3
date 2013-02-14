Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084Ab3BNWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:52:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:52:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 6/9] drm/pci: move drm_pcie_get_speed_cap_mask inside #ifdef CONFIG_PCI
Date: Thu, 14 Feb 2013 22:52:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de> <1360880818-4071454-7-git-send-email-arnd@arndb.de> <CAOMZO5AbTC+82KKTqWXeseahsasx2q=q-4k9u14xyBYhgm2gdQ@mail.gmail.com>
In-Reply-To: <CAOMZO5AbTC+82KKTqWXeseahsasx2q=q-4k9u14xyBYhgm2gdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302142252.06878.arnd@arndb.de>
X-Provags-ID: V02:K0:xq4zQ7i3YCviO7OAzH1ILUL0BYYfYhBShDGnlnMtGya
 x4Z54I7FXDQzpKNTCsQxMfX524+78/+cdB/6W1CkEgmSZn75+5
 E2KC22fWwNYo/vakBYstza5PxO9rCc/rO4y3Q6XEa5G4wy01eD
 P7wBkp8drQ7hXovGMNVN7yI8msMhUwTMtLLojuQ7LHiYIgsFQW
 ThINIK3YYyAbO3jzNeEL4ourOAEq+FgbEt0sHRY7t6aY8tU9EP
 2mUksZV8Odkk/yACZIYgiIrcGUAekyqyAA2iJl1W3TLO+f3MWn
 zp7fvig9PeSjKUGZlTlPcTU9TQbQWYdgCJPuZPaj/YmkNn66sn
 kbH2DsS+tpC8daeWKC8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Fabio Estevam wrote:
> Bjorn has already sent a fix for this problem:
> http://www.spinics.net/lists/arm-kernel/msg224425.html

Ok, excellent.

The result seems to be identical, although patch is formatted
differently.

Acked-by: Arnd Bergmann <arnd@arndb.de>

for Bjorn's patch.

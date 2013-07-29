Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3G2Ocs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:32:48 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48355 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753437Ab3G2Ocr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:32:47 -0400
Date: Mon, 29 Jul 2013 11:32:23 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: dove: switch to DT MBus
Message-ID: <20130729143222.GB2417@localhost>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sebastian,

On Mon, Jul 29, 2013 at 02:31:49PM +0200, Sebastian Hesselbarth wrote:
> This patch set converts DT based Dove boards to DT probed MBus to be
> introduced with v3.12.
> 
> The first two patches prepare Dove DT nodes for MBus ID remapping by using
> preprocessor includes and adding the MBUS_ID macro. The third patch adds a
> MBus DT node to Dove SoC dtsi with required ranges for internal MBus and
> AXI registers, and PCIe mem and I/O apertures. The forth patch relocates
> the nodes for the internal devices to the new MBus node. Also, internal-regs
> ranges are updated to allow proper translation of MBus children's reg
> properties. Finally, legacy MBus init is replaced by DT based MBus init
> for DT based Dove.
> 
> The patch set depends on the MBus device tree patches that should appear
> in v3.12. Currently, it is based on v3.11-rc2 with Dove DT cleanup patches
> and MBus patch set v8 applied.
> 
> The patch set is _not_ sent to devicetree mainling list, because the MBus
> binding will be discussed there on the MBus patches itself.
> 
> Sebastian Hesselbarth (5):
>   ARM: dove: use preprocessor on device tree files
>   ARM: dove: add MBUS_ID macro to Dove DT
>   ARM: dove: add MBus DT node
>   ARM: dove: relocate internal registers device nodes

Great, thanks for doing this. I just have a minor suggestion
on the patch 4/5 "ARM: dove: relocate internal registers device nodes".

Regards,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

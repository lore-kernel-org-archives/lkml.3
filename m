Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3BFW2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:28:07 -0500
Received: from mail4.bemta7.messagelabs.com ([216.82.255.53]:25163 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757756Ab3BFW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:28:04 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1360189528!7136138!49
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] cleanup pcmcia driver module boilerplate
Date: Wed, 6 Feb 2013 15:26:23 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061526.24238.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new helper macro to remove the module boilerplate code
in pcmcia drivers.

Use the new macro throughout the tree where possible.

H Hartley Sweeten (11):
  pcmcia/ds.h: introduce helper for pcmcia_driver module boilerplate
  drivers/ata: use module_pcmcia_driver() in pcmcia drivers
  drivers/bluetooth: use module_pcmcia_driver() in pcmcia drivers
  drivers/isdn: use module_pcmcia_driver() in pcmcia drivers
  drivers/mmc: use module_pcmcia_driver() in pcmcia drivers
  drivers/net: use module_pcmcia_driver() in pcmcia drivers
  drivers/parport: use module_pcmcia_driver() in pcmcia drivers
  drivers/scsi: use module_pcmcia_driver() in pcmcia drivers
  drivers/tty: use module_pcmcia_driver() in pcmcia drivers
  drivers/usb: use module_pcmcia_driver() in pcmcia drivers
  sound/pcmcia: use module_pcmcia_driver() in pcmcia drivers

 drivers/ata/pata_pcmcia.c                  | 14 +-------------
 drivers/bluetooth/bluecard_cs.c            | 15 +--------------
 drivers/bluetooth/bt3c_cs.c                | 15 +--------------
 drivers/bluetooth/btuart_cs.c              | 15 +--------------
 drivers/bluetooth/dtl1_cs.c                | 15 +--------------
 drivers/isdn/hardware/avm/avm_cs.c         | 14 +-------------
 drivers/isdn/hisax/avma1_cs.c              | 14 +-------------
 drivers/isdn/hisax/elsa_cs.c               | 14 +-------------
 drivers/isdn/hisax/sedlbauer_cs.c          | 14 +-------------
 drivers/isdn/hisax/teles_cs.c              | 14 +-------------
 drivers/mmc/host/sdricoh_cs.c              | 20 +-------------------
 drivers/net/arcnet/com20020_cs.c           | 14 +-------------
 drivers/net/can/sja1000/ems_pcmcia.c       | 13 +------------
 drivers/net/can/sja1000/peak_pcmcia.c      | 13 +------------
 drivers/net/ethernet/3com/3c574_cs.c       | 14 +-------------
 drivers/net/ethernet/3com/3c589_cs.c       | 14 +-------------
 drivers/net/ethernet/8390/axnet_cs.c       | 14 +-------------
 drivers/net/ethernet/8390/pcnet_cs.c       | 14 +-------------
 drivers/net/ethernet/amd/nmclan_cs.c       | 14 +-------------
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c  | 14 +-------------
 drivers/net/ethernet/smsc/smc91c92_cs.c    | 14 +-------------
 drivers/net/ethernet/xircom/xirc2ps_cs.c   | 16 +---------------
 drivers/net/wireless/airo_cs.c             | 14 +-------------
 drivers/net/wireless/atmel_cs.c            | 14 +-------------
 drivers/net/wireless/b43/pcmcia.c          |  4 ++++
 drivers/net/wireless/hostap/hostap_cs.c    | 15 +--------------
 drivers/net/wireless/libertas/if_cs.c      | 25 +------------------------
 drivers/net/wireless/orinoco/orinoco_cs.c  | 16 +---------------
 drivers/net/wireless/orinoco/spectrum_cs.c | 16 +---------------
 drivers/net/wireless/wl3501_cs.c           | 14 +-------------
 drivers/parport/parport_cs.c               | 14 +-------------
 drivers/scsi/pcmcia/aha152x_stub.c         | 14 +-------------
 drivers/scsi/pcmcia/fdomain_stub.c         | 14 +-------------
 drivers/scsi/pcmcia/nsp_cs.c               | 17 +----------------
 drivers/scsi/pcmcia/qlogic_stub.c          | 13 +------------
 drivers/scsi/pcmcia/sym53c500_cs.c         | 16 +---------------
 drivers/tty/serial/8250/serial_cs.c        | 14 +-------------
 drivers/usb/host/sl811_cs.c                | 15 +--------------
 include/pcmcia/ds.h                        | 12 ++++++++++++
 sound/pcmcia/pdaudiocf/pdaudiocf.c         | 15 +--------------
 sound/pcmcia/vx/vxpocket.c                 | 14 +-------------
 41 files changed, 55 insertions(+), 539 deletions(-)

-- 
1.8.1.1.293.gfe73786


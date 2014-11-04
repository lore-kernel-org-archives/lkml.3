Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaKDH4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:56:38 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:40490 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaKDH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:56:37 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-178.messagelabs.com!1415087782!29830972!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.4; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 04 Nov 2014 08:56:22 +0100
Date: Tue, 4 Nov 2014 08:56:17 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-kernel@vger.kernel.org>
CC: Andreas Werner <andreas.werner@men.de>,
        Thomas Dorsch <thomas.dorsch@men.de>
Subject: IPC via PCIe
Message-ID: <20141104075611.GA27765@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

has anyone ever done IPC between two Nodes in a System via PICe? I know that I
must set one of my nodes to PCIe endpoint mode (the PPC's PCIe controller is
capable of doing this so no problem), but how will the communication be done?

For AMP settings I've found the remoteproc and rpmsg frameworks and there is
rionet for RapidIO, but no example of PCIe communication.

Thanks,
	Johannes

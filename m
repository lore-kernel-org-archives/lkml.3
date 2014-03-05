Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaCEQqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:46:39 -0500
Received: from senator.holtmann.net ([87.106.208.187]:32960 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaCEQqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:46:38 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] Revert "Bluetooth: Use devname:vhci module alias for virtual HCI driver"
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1394020752-6186-1-git-send-email-thomas@archlinux.org>
Date: Wed, 5 Mar 2014 08:46:26 -0800
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7E804DF3-E191-427E-8E20-FE6ECDC490EA@holtmann.org>
References: <1394020752-6186-1-git-send-email-thomas@archlinux.org>
To: =?iso-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> Adding the devname:vhci alias and thus adding a static /dev/vhci device node
> only works when assigning a fixed major/minor number. However, the code
> currently uses a dynamically assigned minor number. It is therefore impossible
> to create a static device and to autoload the module when accessing it.
> 
> Reverting this fixes the kmod error message
> depmod: ERROR: Module 'hci_vhci' has devname (vhci) but lacks major and minor information. Ignoring.
> 
> This reverts commit bfacbb9aec029b3200053d84c8cd5d7575f2d4a5.

NAK. We allocated a static minor for this.

Regards

Marcel


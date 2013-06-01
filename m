Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3FAEzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:55:16 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:49379 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab3FAEzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:55:12 -0400
Message-ID: <1370062502.2606.5.camel@obelisk.thedillows.org>
Subject: Re: [PATCH] HID: fold ps3remote driver into generic Sony driver
From: David Dillow <dave@thedillows.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 00:55:02 -0400
In-Reply-To: <alpine.LNX.2.00.1305281538360.3914@pobox.suse.cz>
References: <alpine.LNX.2.00.1305281035370.3914@pobox.suse.cz>
	 <1369747847.3675.3.camel@obelisk.thedillows.org>
	 <alpine.LNX.2.00.1305281538360.3914@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 15:45 +0200, Jiri Kosina wrote:
> I'd be glad if you could provide your Tested-by: for the patch below. 
> Thanks a lot.

I tried to test this tonight, but was thwarted by Fedora 16 on the only
readily available test platform -- old bluetoothd w/ the internal
driver. I'll need to upgrade that box, recreate the updated bluetooth
environment I had from some time ago, or try it on my myth frontend
(Ubuntu 13.04). I'll get another chance on the 9th; I won't have access
to the HW again until then. :/


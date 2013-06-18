Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3FRJvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:51:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab3FRJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:51:40 -0400
Date: Tue, 18 Jun 2013 11:51:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: i2c-hid: add DT bindings
In-Reply-To: <1371109835-30796-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1306181151030.6750@pobox.suse.cz>
References: <1371109835-30796-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Benjamin Tissoires wrote:

> Add device tree based support for HID over I2C devices.
> 
> Tested on an Odroid-X board with a Synaptics touchpad.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi guys,
> 
> well, as the commit message says, this is the DT binding for HID over I2C.
> I honestly don't know if it will be used besides me, but it may help others
> with a DT based board.
> As the spec is for ACPI only, I had no specifications regarding the DT names. So
> these names can be changed if you think they are bad.
> 
> I also created a new bindings directory in the devicetree doc to reflect the
> split we have between input and hid. However, if the DT experts prefer having
> it under input, I'm fine with that.
> 
> Cheers,
> Benjamin
> 
>  .../devicetree/bindings/hid/hid-over-i2c.txt       | 28 ++++++++++++++
>  drivers/hid/i2c-hid/i2c-hid.c                      | 44 +++++++++++++++++++++-
>  include/linux/i2c/i2c-hid.h                        |  3 +-
>  3 files changed, 73 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hid/hid-over-i2c.txt
> 
> diff --git a/Documentation/devicetree/bindings/hid/hid-over-i2c.txt b/Documentation/devicetree/bindings/hid/hid-over-i2c.txt

DT folks, any objections to this, please?

If not, I'd like to apply this for 3.11 into my tree.

Thanks.

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab3BSSkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:40:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32408 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:40:13 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rDcwfYOOLE=
X-RZG-CLASS-ID: mo00
Date: Tue, 19 Feb 2013 19:40:09 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Message-ID: <20130219184009.GA21783@aepfle.de>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130219165118.GA17715@aepfle.de>
 <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
User-Agent: Mutt/1.5.21.rev5638 (2013-02-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, Haiyang Zhang wrote:

> The emulated video device is a separate device from the synthetic video.
> The synthetic driver can only take control of the synthetic video, but not
> the emulated video.

Please add this to the comment above.

> Actually, we already have a similar mechanism in ata/ata_piix.c to disable
> emulated IDE drive on Hyper-V, so it won't conflict with the synthetic drive.

I havent read the vesafb code, but I think it can kind of give up the
hardware, something ata_piix can not do.

Olaf

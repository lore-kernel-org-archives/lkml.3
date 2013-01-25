Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3AYUAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:00:11 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:61130 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3AYUAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:00:09 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGji0LFus=
X-RZG-CLASS-ID: mo00
Date: Fri, 25 Jan 2013 21:00:00 +0100
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Message-ID: <20130125200000.GA9712@aepfle.de>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
 <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5632 (2013-01-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, KY Srinivasan wrote:

> Your current approach of using the "Partition Reference Counter"
> feature bit is very fragile. Let us assume that future Windows guests
> depend on this feature; Xen would certainly emulate this to have a
> "good" emulation of Hyper-V and we are back to square one.

If Xen starts to emulate the "Partition Reference Counter" feature,
wouldnt it also advertise this feature?

Olaf

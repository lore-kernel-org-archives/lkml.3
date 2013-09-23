Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3IWVS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:18:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35090 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3IWVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:18:56 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, dan.carpenter@oracle.com,
        linux-input@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support Hyper-V synthetic keyboard
Date: Mon, 23 Sep 2013 14:18:49 -0700
Message-ID: <9413886.ODbxHZ6JJT@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.5 (Linux/3.10.11-100.fc18.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130923210812.GA19953@aepfle.de>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com> <20130918210107.GA32320@core.coreip.homeip.net> <20130923210812.GA19953@aepfle.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 23, 2013 11:08:12 PM Olaf Hering wrote:
> On Wed, Sep 18, Dmitry Torokhov wrote:
> > This looks much better. Could you tell me if the patch below (on top of
> > yours) still works?
> 
> The help text is slightly incorrect, its a dash not underscore:
> drivers/input/serio/hyperv-keyboard.ko

Module code converts all dashes to underscores if you check lsmod.

Thanks.

-- 
Dmitry

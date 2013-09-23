Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3IWVIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:08:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:52292 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3IWVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:08:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/cwapwKA==
X-RZG-CLASS-ID: mo00
Date: Mon, 23 Sep 2013 23:08:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, dan.carpenter@oracle.com,
        linux-input@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Message-ID: <20130923210812.GA19953@aepfle.de>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com>
 <20130918210107.GA32320@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130918210107.GA32320@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, Dmitry Torokhov wrote:

> This looks much better. Could you tell me if the patch below (on top of
> yours) still works?

The help text is slightly incorrect, its a dash not underscore:
drivers/input/serio/hyperv-keyboard.ko

Olaf

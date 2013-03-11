Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3CKDba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:31:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49777 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab3CKDb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:31:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1] very poor interrupt responses
Date: Mon, 11 Mar 2013 04:38:31 +0100
Message-ID: <7791757.cgjzv69Ulu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2663178.G2EStYDi2n@segfault.sh0n.net>
References: <2663178.G2EStYDi2n@segfault.sh0n.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 08, 2013 02:12:33 PM Shawn Starr wrote:
> Hello folks,
> 
> I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.

Please try to disable the intel_pstate driver by putting intel_pstate=disable
into the kernel's command line and see if that helps (you may also try to
compile the driver out).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

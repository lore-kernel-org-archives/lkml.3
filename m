Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3BLNbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:31:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab3BLNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:31:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the metag tree
Date: Tue, 12 Feb 2013 13:31:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Mark Rutland <mark.rutland@arm.com>
References: <20130212145601.09b536bef18ae4f3c8d3b3cc@canb.auug.org.au>
In-Reply-To: <20130212145601.09b536bef18ae4f3c8d3b3cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121331.10646.arnd@arndb.de>
X-Provags-ID: V02:K0:ONHpF3vwyRDdBaoQPys7u+dyDytOAqWE9bQWhRDzvE1
 7iCeWidV4JRhaQCpuN8bzre8//CTamzVmjWgGr72x17Ky19TiI
 OLfAVPN9Si1xy/IMmBQTrsf+dDPRomET6SwFA9ph2D/5poGqFp
 sdE07YporgPl+C4BSnsj57jvQhrJnNKrM6vALhPktlIkGKh4gY
 0VrkKPibwFPw7k1FkDEtEQLL5n/oMm1GgHDAp+0+H6/3dBl+ux
 MqF/qM1Of3d6oEeNMvlXA9gdPAa3JW80P/ZGikfN32ZBTXUSgn
 0ZRazOi8y0TnK+YECXTc/ys+wf8ndJo1niRE8TYMNI3sDS82oK
 5abPiS4tCEpdRHh+GfCw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got conflicts in
> drivers/clocksource/Makefile and drivers/clocksource/Kconfig between
> commit 3fedb0674fbc ("metag: Time keeping") from the metag tree and
> commits 8a4da6e36c58 ("arm: arch_timer: move core to
> drivers/clocksource") and  ("arm64: move from arm_generic to
> arm_arch_timer") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Thanks, looks good.

	Arnd
